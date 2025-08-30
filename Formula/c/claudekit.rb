class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.8.7.tgz"
  sha256 "991256dcd16beefcfb00be1d002448098d02ce2147075e4e62d6d181bd3e6949"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86b5124d51e605dfd5006a1f603500ed316e6a4c2879866e55e8be11a8ba4e7c"
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