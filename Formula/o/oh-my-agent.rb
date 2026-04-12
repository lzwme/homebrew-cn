class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.27.0.tgz"
  sha256 "4c06bab8a0fe665e0035f723564e81d0bc43aa28f80af9fea5ee7c1830d6196f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5241237c12338b6e745d038b6d6c238c04ba3f2c4f02f901714ca98600ede712"
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