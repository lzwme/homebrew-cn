class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-18.0.9.tgz"
  sha256 "24969ffa583e1a4daee68d3884c32ecfaddc39a9989c710d960e37fa4c806e12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c28fc3bbdfaa52c30345dfb939fdefdea186efcf935605e85b461652812841bf"
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