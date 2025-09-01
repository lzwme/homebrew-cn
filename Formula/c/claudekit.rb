class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.8.11.tgz"
  sha256 "162eeeb1c4df77e0f2433659702d423f5f344f1501014cfcbb888557dbac27a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f631c6146916f81e277fa41886e10f0245ca976667a5e35d38af9ad13121a40"
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