class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.29.7.tgz"
  sha256 "a7887b6b6a4bb70c15c0e33b6b2ed7e0e284bec2d0f73f4640878ab1cf8f1c74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e4f1c7efcfb4c88d53e17301b1a90ea87172c0080c7b65cb48de6c1b5dda227"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cct --version")

    output = shell_output("#{bin}/cct --command testing/generate-tests --yes")
    assert_match "Successfully installed 1 components", output
  end
end