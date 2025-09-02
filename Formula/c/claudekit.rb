class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.8.12.tgz"
  sha256 "3eb7b8dce146b4806e0a9365156d10338dc403f76c8952f336007118c275e4fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04147d51d0adcc1881de7d89cb362bdb17dcc32c50c2007465883843a1a62440"
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