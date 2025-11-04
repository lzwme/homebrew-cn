class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.27.0.tgz"
  sha256 "3ee7fa8c3a60d2fe5bb7cd8650381a337af803acbd55dc47314292930d4bf770"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29a77311b7c48121d23552b94157e98d776ce0da5f3e55d8fa034b8e83526a94"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cct --version")

    output = shell_output("#{bin}/cct --command testing/generate-tests --yes")
    assert_match "Successfully installed 1 components", output
  end
end