class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.8.0.tgz"
  sha256 "8d74f1bc2830d81a5d81aa5ca6045df6a5e2330d36520f0cd0e7d911c7a781c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ab29601773254af8fd5ee4c1bcf0a56ad83b2d5180f67c253686f9dacfffb3a"
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