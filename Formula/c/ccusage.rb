class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-17.1.4.tgz"
  sha256 "50beedb93fd1bf68703f7eaab6ca30c8092ac017d574556e75254977108011c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "983f11ea17ba237da5a083e4af51e3eedad2463d77d889db0dc974f10ac5373e"
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