class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-16.1.1.tgz"
  sha256 "2320e389712dbaace527893bea0978eef4dbec907c943009bb1ff8e56b136b53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61884f5241b9643af246f1df0992c0a1bb0c8764d39d3b270f35d4f2dc67a71e"
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