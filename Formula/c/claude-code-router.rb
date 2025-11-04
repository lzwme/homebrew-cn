class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-1.0.65.tgz"
  sha256 "47c1b64a75bc554d6de540cde652b6c77591cc6edc6068e82fde04368382be16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65572088d2d4b1c7185c79f140cd53c12785423d315da5dfb7ce2916113ef344"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccr version")
    assert_match "Status: Not Running", shell_output("#{bin}/ccr status")
  end
end