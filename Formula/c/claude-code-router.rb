class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-1.0.68.tgz"
  sha256 "b9543a8d410f8649b2d66f006f46c9045562b269c6c5743238413551fa7797a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6707f71ee88c8de9eaae9be6f3583c6e22c1188035639c340b2944cdd926d88b"
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