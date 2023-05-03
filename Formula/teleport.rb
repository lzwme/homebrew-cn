class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v12.3.0.tar.gz"
  sha256 "1be3240c0a2412484a01a5bc81a9d0f3db412002b01034ea580268d0e9c2e142"
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
    sha256 cellar: :any,                 arm64_ventura:  "d752a1bb40f4b9e4bf6bb8bd7a7f58d57916f01f7e2322d3b5f1efda137ac403"
    sha256 cellar: :any,                 arm64_monterey: "9c76699cb9c8ffaba017d9b20b5bd124708797947f80dce719d146365a27b33e"
    sha256 cellar: :any,                 arm64_big_sur:  "cfe34703573d9a1721ef2d695034ca16e9f13256d41e2308141e0a0e89b81442"
    sha256 cellar: :any,                 ventura:        "e8d832fed6ad6d877f71ed3462afd752294d2aab0bbec6e2d305bdd9de5a10b8"
    sha256 cellar: :any,                 monterey:       "7d766dfef821e61c6cebda0b752f0bfa68236010eb2b6f15123643ffc13b3fde"
    sha256 cellar: :any,                 big_sur:        "467a214b6e43efe025acc2a7b76c8f1f5d914565fa04a6b3c4e8963bd2d93ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b556782d83618696cc21d8c8916260ade4ea9d0d2348531ef188dc80b418ddbb"
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