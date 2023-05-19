class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://ghproxy.com/https://github.com/gravitational/teleport/archive/v13.0.2.tar.gz"
  sha256 "f4c4e905e135b1859ea05c79ab14889c8ee50af5451fb6013ca55d119df2b0a8"
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
    sha256 cellar: :any,                 arm64_ventura:  "afaded160093fb2dbc8d3db22a461aba2fa289894c735a78d25425a1bd47f6b7"
    sha256 cellar: :any,                 arm64_monterey: "76706fce8fbb10bc73f71fda2af8b6ec17d2be972c349c894dd080ce4689eff8"
    sha256 cellar: :any,                 arm64_big_sur:  "263ba85bac80e2f8b0c57231fcea0028f3ead608583f7d44e00abcab32ae49c1"
    sha256 cellar: :any,                 ventura:        "847da8a0f4ccb2c028c7c2d6a4f292006c69bff26d9b676285419702d96894cf"
    sha256 cellar: :any,                 monterey:       "0ff63ecc4d6594bf2e7a33ac05251d97efefd27496de33cc23055793d5e5df32"
    sha256 cellar: :any,                 big_sur:        "acba8b7768ab18f09e67c0e79dc4d6211c4fe24327510307a8cd8a558ebdd978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36a4be4bdaee6ee2da8b6114e56aae04b13285ba4239330ea878ed51ce57d21f"
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