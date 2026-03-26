class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.9.0.tgz"
  sha256 "1d18c92f68a44d06fbd5784697a9d380b2b1322ebf8a80a37a248e32e744bcbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22732841a8aeeb01344990736a6ff35fe45c5b737ce0de267e4f722fd05bb4c3"
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