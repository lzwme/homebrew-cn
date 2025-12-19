class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-1.0.73.tgz"
  sha256 "4c087ea9d998e9b705461127a55626af282ce4e3e6ae86f4496181721ecfd968"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e007dd2501cb70432b41016d686032642b6d11a49b83df7fddc9ceed3e12e39c"
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