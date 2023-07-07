class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v13.2.0.tar.gz"
  sha256 "d791e54f4dc3e26fb7319ec4eb3bdc9a004338baf8f4d371d58e1853450e8bcb"
  license "Apache-2.0"
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
    sha256 cellar: :any,                 arm64_ventura:  "a3b07a0c597a2db390ca67ba6d923c9c8563b2aeb9526d526ff0917fea281d78"
    sha256 cellar: :any,                 arm64_monterey: "03c2ecbb0535e9d0039fb3c92b194e3182f5dc93269c6cfaf0800797dba7ead2"
    sha256 cellar: :any,                 arm64_big_sur:  "e4622d4b180c40ea8923873ec12d49bdcec85d3deba4fa98c065d68e4b35ed93"
    sha256 cellar: :any,                 ventura:        "95178d5dc5b24095f3d4427854ce25e35dfa5e86e49dc5debe7f02f3cfb4790c"
    sha256 cellar: :any,                 monterey:       "476debf2de28738c8525e27466b24f4fe0af359cceb2df7be87bc352b043f87c"
    sha256 cellar: :any,                 big_sur:        "24a88d796bd12d9997400902a86411c63c9be73a1fffd5e2361b72e07f259630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ac44810c09b49ad0f154bd401e6c91e8b97dc9b76e3fd4130a82d89b17c75f"
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