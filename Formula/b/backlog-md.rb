class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.8.2.tgz"
  sha256 "60ed0319797853d910dc3f23b70e021285d3106d9a07892abf3d08be482c1f5e"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "3e6d510c8a33db1760d6221d034c255b1e6b558d09c5b7ffd0d2bad1b5df4fbf"
    sha256                               arm64_sonoma:  "3e6d510c8a33db1760d6221d034c255b1e6b558d09c5b7ffd0d2bad1b5df4fbf"
    sha256                               arm64_ventura: "3e6d510c8a33db1760d6221d034c255b1e6b558d09c5b7ffd0d2bad1b5df4fbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "08fc32869f1a3a01c12c90a6d432bfa629d2b42b0c307d5d8398539381dfca6d"
    sha256 cellar: :any_skip_relocation, ventura:       "08fc32869f1a3a01c12c90a6d432bfa629d2b42b0c307d5d8398539381dfca6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "275dd9504a6d73abd419eb9113d18fb9ed02daa275c99ed730a7396a77d4205c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4eb4294227f54a23537a8700b59283a9f41192d0da71368ca6fdc3a0acf02909"
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