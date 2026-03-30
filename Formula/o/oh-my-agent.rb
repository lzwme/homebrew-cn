class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-4.15.2.tgz"
  sha256 "2c38c4a27ea1ed60a3f13d229071e0dc10ca661d7c6ff9dce321502a4fa378ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87583ee60210eea4e0bcd0bf25d11d961d33c3785ca8437adefb5cb4eef8dfca"
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