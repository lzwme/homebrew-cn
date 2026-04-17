class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.4.4.tgz"
  sha256 "6b0808b847d9df15e1bcfbd6feb6a2db9b68340733b87fce6aca330467653978"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e8e17ff91c88ce78776cf8ad9bb95891e1ffa03c68d525c946936a80a6da286"
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