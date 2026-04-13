class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.29.0.tgz"
  sha256 "3e7863b628c5c73cd7a08275d5714bbe18bbc754c90102073f48e4e555e4f04a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f4aee8fc2f727de14ff604c1465c596e856b5d70b8ae97fb7e52b2510ddd141"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end