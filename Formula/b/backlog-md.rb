class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.8.0.tgz"
  sha256 "a3146e0a6d86dd984268422dfebaac1ef09b177dbca9383e56bcb2e01a61b8dd"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "9b1fcfe310cd65ee8e77495f6dd3acc2cc1e0d8e86ed52c747510fc962674f29"
    sha256                               arm64_sonoma:  "9b1fcfe310cd65ee8e77495f6dd3acc2cc1e0d8e86ed52c747510fc962674f29"
    sha256                               arm64_ventura: "9b1fcfe310cd65ee8e77495f6dd3acc2cc1e0d8e86ed52c747510fc962674f29"
    sha256 cellar: :any_skip_relocation, sonoma:        "bac39a82f55bbc05db86f33b7ff01e421596b5fa94238dbc32972b8541f07e0c"
    sha256 cellar: :any_skip_relocation, ventura:       "bac39a82f55bbc05db86f33b7ff01e421596b5fa94238dbc32972b8541f07e0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a57fb97d3c02d5aedb2cc8c6e38b4acd3c78fc7377d4248224aa37c524fb0676"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a668ae2e3fcd2c4c1c82757ed449f7cc4fc34eb3d1cd5f981d88803e8b83944"
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