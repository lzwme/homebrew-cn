class Claudekit < Formula
  desc "Intelligent guardrails and workflow automation for Claude Code"
  homepage "https://github.com/carlrannaberg/claudekit"
  url "https://registry.npmjs.org/claudekit/-/claudekit-0.9.1.tgz"
  sha256 "1b398ee5a40c991e742cee737832ee699f184927474c1f2eb11168bb7669738c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d3b88d484b8a1945648d2fe8ea737140367abd2d255c94434952a2486e5835a3"
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