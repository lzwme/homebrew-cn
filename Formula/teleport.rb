class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v12.3.2.tar.gz"
  sha256 "48659a4b54b500c07f38f8fab43f0ce99b69cdf79a78aac039de241edf0b31d8"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4f479cb57b3c59122d1414d4c4755fe43d19a81a8aa5edb31372d5a4bd012998"
    sha256 cellar: :any,                 arm64_monterey: "bfafac9a0b8fcefdbe555215016c1b1ceb45669f46d584c30688993453cc3759"
    sha256 cellar: :any,                 arm64_big_sur:  "020c238e5d4cdf609721820e2af43d6544a411031b475691985769afc8322864"
    sha256 cellar: :any,                 ventura:        "3388f04997e899c4a9d9bedd487fcf47e48af38d59d5d2507a8de2abc919d3f5"
    sha256 cellar: :any,                 monterey:       "6ea8f950e51f401cc48b98b36d375e63dda022f12ef22fc47802953d4145404a"
    sha256 cellar: :any,                 big_sur:        "237a01b89afc75342d246d8878ef687c5ad8dac7e0505aa52d2b34a9fec6a78f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b8bef74f647c97916a9df23419964a512ff11a0df3c3f9076948d6c47e2332"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  def install
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end