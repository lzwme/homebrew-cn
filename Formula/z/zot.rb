class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.76.tar.gz"
  sha256 "39a332998aa4c28ae9a3bbc40f9ba9ab66256c439556bf9a7cab1817fce8944e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52a106607d368d4e4ca113da554c49081fa65370eee1bd80e806a23ff30e93a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52a106607d368d4e4ca113da554c49081fa65370eee1bd80e806a23ff30e93a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52a106607d368d4e4ca113da554c49081fa65370eee1bd80e806a23ff30e93a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "25c87c2d1e8a6e4a71cfa6979aa5c363c965c914d88682621e3cee19ccec538f"
    sha256 cellar: :any,                 x86_64_linux:      "813fd1aeaf61f7a9e7bbc979d4ad5d356824abc22549a98d2b77054d8f05224b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end