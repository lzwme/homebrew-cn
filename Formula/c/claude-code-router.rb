class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-1.0.64.tgz"
  sha256 "41dda7ca6afca38db8ca5c522d825673cde5e0bdbc5ac1c8b7d31a9a5ee4fcaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1fcb78dfc5a3ba7a2ede78f04adb4306d2f592a72a49d27de52ce2e03d09570"
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