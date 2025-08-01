class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.6.5.tgz"
  sha256 "1a97a8babf97defc459dac86283fc745435b4953473f5b64a119d4c7be29603d"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "2a5597642ef4412d98c0a2b24b3ed7203c4c4896e40362db4b50feeebd7a75bd"
    sha256                               arm64_sonoma:  "2a5597642ef4412d98c0a2b24b3ed7203c4c4896e40362db4b50feeebd7a75bd"
    sha256                               arm64_ventura: "2a5597642ef4412d98c0a2b24b3ed7203c4c4896e40362db4b50feeebd7a75bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "065d55ffc7ef7aeb8c9a73314cbb364fb7c0f940f59cb8e316861390c71f12ff"
    sha256 cellar: :any_skip_relocation, ventura:       "065d55ffc7ef7aeb8c9a73314cbb364fb7c0f940f59cb8e316861390c71f12ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "393fa5ad909a68484199970f0ef24709d706f2c3e02b5dfb861aa87a987ff08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20f32c18780c873b225a69fc15130a8392777e73448a38b7b55e48805505df16"
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