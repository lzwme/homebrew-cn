class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.2.2.tgz"
  sha256 "7856839bb0b4b98b94dfe73eac7523eeea590bb3243a91f7a387f8c7efa509f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec4ecdd162272c948a0adc40527a862934fea1a37bb1197e9da044f2eb161d85"
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