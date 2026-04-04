class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.22.1.tgz"
  sha256 "3c3e02ea7bc07c10b13087d9b904db5043b6352f500802d1de24c0b597b709fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "616aaf42acdbfe4dff792b407d48f01bf74c97a9855cf39219c7bd5005927f51"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-ag --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-ag memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end