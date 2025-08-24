class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-16.2.0.tgz"
  sha256 "fdc3961b555ec911a011af0dd0a355acf930b5877c0f9213a7f4345531d8b05f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5e3d2bb1555e191b2075556fa949b58682bc6e86fe75ab3fc29d7b77b4fb0fe8"
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