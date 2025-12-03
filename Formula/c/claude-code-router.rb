class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-1.0.72.tgz"
  sha256 "021924a34b3249f333f7cbb7c1fcd4bccdfd2dbfaea05b0c2548c23ef82bf2cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3acf60e96236587c245142ddfa92ff4ff1a310897f3ae7ab99f3bf6eb390fa4"
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