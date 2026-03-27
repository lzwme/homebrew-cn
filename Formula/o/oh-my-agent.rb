class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.11.0.tgz"
  sha256 "e87b9357409ab08f08ec478d959b50f9525f2cb187281bc7e319f8dc7aeb77c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a4fcdaf84a57190856a1c9f710711d64279707f57a74d53e23fbd555f73e27d1"
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