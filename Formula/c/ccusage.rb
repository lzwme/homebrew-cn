class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-19.0.1.tgz"
  sha256 "b1f905168a02b22d40a006e349f51a84a574176e29e4b1ccc903ee83240dc825"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c3b1dba3495f9e1501812aef13af1489ddcbf73f008da83684430b5fb311c8d"
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