class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v13.1.2.tar.gz"
  sha256 "d3fb8502ad82c06ed4605cbfca57cc1cf3da2ede0ac9c6d39b95147bd6e15f58"
  license "Apache-2.0"
  revision 1
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "900119f2bd93013d46521bffc9919f054c9ddbb199119b385fb2d7bd65e77456"
    sha256 cellar: :any,                 arm64_monterey: "04568717b19aab9eb40439c871f2facdfc0bdc62d6af8e4b90311324c7b15505"
    sha256 cellar: :any,                 arm64_big_sur:  "b82ee55fc11b9a424f790d23c06d24a9596af45793cf3331e3050cb36459903f"
    sha256 cellar: :any,                 ventura:        "d1b23789b4ad89f2d629167502ad9db441d65d5ceefb40df0dd882ea89e6b90a"
    sha256 cellar: :any,                 monterey:       "599646b788ddca776a996685604cbc33cf0730e51fe9bf60dbbe37e47fedd7f8"
    sha256 cellar: :any,                 big_sur:        "70ab1bed95bcec6d8a9748dddc9f6558e50f8598fcf6f0236d20ccefdf48a6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1622b23f779063e027fda818a5f5c2f252f425640f3712c6ca305bc1a133acd"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

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