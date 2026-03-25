class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.8.0.tgz"
  sha256 "2770e0b4b50072d5a77d637ba1c0ec3befda59480d584df42a0b1d0ebec3e949"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2200db4495778ab719cedd2a589b15ccc9eb46ebd709a2dd93f60387a269aabd"
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