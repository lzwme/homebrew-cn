class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-16.1.2.tgz"
  sha256 "c55c0bcd16767ef888d18eee04eeae43d2bbf970f40e0531d9b71f2ca16201af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "780e558da61b09336b6eec1f314892afa4504de22013f75eadbf2f76281f1a7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end