class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-19.0.3.tgz"
  sha256 "103384865cef17a6e4df5d5f9154994b1c9d44dd0ef5240a0b4aa4a7d38c1e4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62520d3aa40c9193ef6f4e4211c16fd4c0453ac1925f7a3259c9ebf959be2be7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "No usage data found", shell_output("#{bin}/ccusage 2>&1")
  end
end