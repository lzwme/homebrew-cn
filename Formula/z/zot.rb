class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.81.tar.gz"
  sha256 "73233e2750800d0fb1d1242a50b61b9f482aaed0167f5c27f54762d7beb43e3a"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0db3b439a76415040781e1e50fa85a4b2e03501567e997433c2ffd051424c2f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0db3b439a76415040781e1e50fa85a4b2e03501567e997433c2ffd051424c2f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0db3b439a76415040781e1e50fa85a4b2e03501567e997433c2ffd051424c2f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1c13242be95c9c8551fddcff6fc08d44cf132f35d0b855a698ae060115c46cdd"
    sha256 cellar: :any,                 x86_64_linux:      "2dafd790b04348916f66e7c0d429d71fef1016f2cd2c0df4d364425151f2e532"
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