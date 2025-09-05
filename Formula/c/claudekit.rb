class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.8.14.tgz"
  sha256 "8744a51d3cc591f6625f2554e88b7e00b1697523c0773e5cd42b8b7e387f5ac9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6a8bfe2d50d3365c37bf4b3ea564750c2aa532655fc582dd2c9a3a768b27b594"
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