class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-19.0.2.tgz"
  sha256 "14131dc780c4ca6904efd7f8cd935f6e79bc0b59ee953cfd8bff5ddf1d3b6c84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3452743bcc421e8774821390e1e48dc9cae9aa3b181568ade034989023f3bf8f"
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