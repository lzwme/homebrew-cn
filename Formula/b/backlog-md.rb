class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.6.7.tgz"
  sha256 "6fbe14175774798bb9aa6203556d341ef3799fdf97b66f7d5e559eee19414ece"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "ee2586fd88a7546211f93bdfca1f23a73b4afd21d53fcbd467137c7b0d3d74b5"
    sha256                               arm64_sonoma:  "ee2586fd88a7546211f93bdfca1f23a73b4afd21d53fcbd467137c7b0d3d74b5"
    sha256                               arm64_ventura: "ee2586fd88a7546211f93bdfca1f23a73b4afd21d53fcbd467137c7b0d3d74b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a1e2f25abad58937eeb799132ff5d447c3fa6a1cfb753f8497692f9f53755db"
    sha256 cellar: :any_skip_relocation, ventura:       "0a1e2f25abad58937eeb799132ff5d447c3fa6a1cfb753f8497692f9f53755db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26abea10d8660c5ff75d405278052a7573a28673bfb2e444e2cf2ee9e3224e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f4f9e9bfe5d89db8815aec500869243368e35baf7f86c912f4f0fdfff5a122"
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