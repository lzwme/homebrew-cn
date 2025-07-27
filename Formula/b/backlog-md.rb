class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.6.2.tgz"
  sha256 "24af726ec1a7103b77b43ea218f34deadb65ff3ca012371bfca6afd67e06a0f0"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "d8efc96a0d96ad6d7302ea449d06c5aa8ba4e444eec9a16f611d6f8b92d97148"
    sha256                               arm64_sonoma:  "d8efc96a0d96ad6d7302ea449d06c5aa8ba4e444eec9a16f611d6f8b92d97148"
    sha256                               arm64_ventura: "d8efc96a0d96ad6d7302ea449d06c5aa8ba4e444eec9a16f611d6f8b92d97148"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c9354e84fb59f8f07d031a2e96bc4d468a7f1f8f554b43178ef013f4eec5096"
    sha256 cellar: :any_skip_relocation, ventura:       "4c9354e84fb59f8f07d031a2e96bc4d468a7f1f8f554b43178ef013f4eec5096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a756f3035b6272664a4ef4ec74a32c4fb67b98d4ebc39588c77abc9b2a6d237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9eb31d4c5f76901cfbfd185e00f45006fd29ad97fc811e6f5424b161aa5083f"
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