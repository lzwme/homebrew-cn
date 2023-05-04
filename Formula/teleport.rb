class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v12.3.1.tar.gz"
  sha256 "c06ea22e780fd5b016d745c687a7782da96683d24503f171f3f1e03d6e8468e9"
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
    sha256 cellar: :any,                 arm64_ventura:  "c28bb372ff2b0c93600268924edb58eda837f47065372d34d2fa86b59514bd42"
    sha256 cellar: :any,                 arm64_monterey: "1e17be447a2dba99b15bf2310309d8653e733fbd2a12a82b4011225751ff1621"
    sha256 cellar: :any,                 arm64_big_sur:  "1cd374783d7d6dde5915ae2ff5378217f8a3a787362380519750adb519bced5b"
    sha256 cellar: :any,                 ventura:        "2a118dcfd3b697388352e0a53ce6266bc342aec4411a593cc51aecdb92bd5b6c"
    sha256 cellar: :any,                 monterey:       "f11dd0639f3a40e05b7a4843e92aff6d14d228b39e9980909be07f3747ab899d"
    sha256 cellar: :any,                 big_sur:        "60952a5e9652651449d289b67e148c5213b2965ba3f6ff114729d13c9b55eca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f52b08013f0a8cbfbe4fe78c94ac2436ed824f1b71569b0c5c4eb3313873d8ad"
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