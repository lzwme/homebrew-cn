class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.8.13.tgz"
  sha256 "b3aa7f5a2c6f42d2f94112e39d731820dd409279741a7549e136f5da2fe17f30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "49a924cf6eb3dc17d4ff908d00ed1a4fc76cc9c248e2a8e4f6012d5ea9617036"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudekit --version")
    assert_match "Hooks:", shell_output("#{bin}/claudekit list")
    assert_match ".claudekit/config.json not found", shell_output("#{bin}/claudekit doctor 2>&1", 1)
  end
end