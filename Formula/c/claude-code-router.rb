class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-1.0.66.tgz"
  sha256 "5876f78b4ac9849abc0623066445f6a0a66815d33972dd6229bf5a261b5c7ecf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9eb96f18684f0b6dad891c19251eace356fb214ef65e5c7854c6fcdf93c29187"
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