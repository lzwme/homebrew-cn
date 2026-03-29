class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.15.0.tgz"
  sha256 "4ab05615171277b50f1035abc90c484b000f4b1ef5aae944ec7fc51cb041f85f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "76e555fd239f35b821da000d0cd9f8b4df0b35f0e8e506bfba75ebba1964a848"
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