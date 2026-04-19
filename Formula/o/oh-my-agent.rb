class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-5.9.0.tgz"
  sha256 "0896f4387bf4a01d9859261100377f98da3d0936de37ef9cb4abe3ce993b63b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "580cc0ff7f0b56df2a8a86a3be54bf09e21e30f723e3a13b4b7e42ac643f675c"
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