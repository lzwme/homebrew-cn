class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.17.2.tgz"
  sha256 "02a2b7962aa315274024d9b52f360db69f1fcb48a81c88b50f950fa8d4e5d8a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc09004dbff899ddee30e1999967fd8ddb75d0622ef516dec79dbe0cfb674a9b"
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