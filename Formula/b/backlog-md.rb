class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.8.3.tgz"
  sha256 "708f795c01aed0c7fa605bd81bae6b8e1a7dd95748798524f884f270cb57c0f1"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "f5777abae8095ce9abb029a7f014793611c6eb4ca1d64c9f6a3dff8ff9379dbd"
    sha256                               arm64_sonoma:  "f5777abae8095ce9abb029a7f014793611c6eb4ca1d64c9f6a3dff8ff9379dbd"
    sha256                               arm64_ventura: "f5777abae8095ce9abb029a7f014793611c6eb4ca1d64c9f6a3dff8ff9379dbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7139795837569bec2e2ca97fc6204d8ec2592f2b028f4e532c48753841410ac8"
    sha256 cellar: :any_skip_relocation, ventura:       "7139795837569bec2e2ca97fc6204d8ec2592f2b028f4e532c48753841410ac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "217b675924589b03ddfbdf385be089ecbcdf9176a351f27507914d6145861b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c61a8a9864ed1373fa671f2fbefd3134ada52db9637d18165321d88f9a19b7d9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    port = free_port
    pid = fork do
      exec bin/"backlog", "browser", "--no-open", "--port", port.to_s
    end
    sleep 2
    assert_match "<title>Backlog.md - Task Management</title>", shell_output("curl -s http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end