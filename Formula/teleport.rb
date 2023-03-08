class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v12.1.0.tar.gz"
  sha256 "b19708b41898050557e967362674d6625a9066fac6b5fad3744209cc9b3ad518"
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
    sha256 cellar: :any,                 arm64_ventura:  "3bbafbc0bc2b676d0853b6ce60b4882825561d41da6b0f9a0e844c3c74a8cb01"
    sha256 cellar: :any,                 arm64_monterey: "ad41ad8dca1b4810bb3cfc428c74042b22fc1c1ed1f7c14427c0cc1c768fe5c7"
    sha256 cellar: :any,                 arm64_big_sur:  "3d3e1cac18cd5b4b5c4b99cc9209e2334ba4d597baaefcc6f37c53d8dbd78323"
    sha256 cellar: :any,                 ventura:        "58ff9ab53d14bfe03ba674f0fbf9134220061f696ad758b4114016d5474f17bf"
    sha256 cellar: :any,                 monterey:       "3e0aec94b3030cb487d9bfb41f128b10f0067b17546220f839bca02c510509dd"
    sha256 cellar: :any,                 big_sur:        "b7190d91ee064bb2f797e787332bba056e443755e01ed74aed8118edadf95b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c113a3b897edad6c432d20d36410856587dc35f7742b52506a58444471d2507e"
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