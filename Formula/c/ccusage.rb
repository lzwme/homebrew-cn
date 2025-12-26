class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.2.0.tgz"
  sha256 "8c28bd43b75ea440541910679dfab4e4bf739c3b3bda2800136f9cae73afda76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ada7d6858777765effc962e4efcf3fb27afa899dd55d13ccc946705aec9428a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end