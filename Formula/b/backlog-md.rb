class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.7.3.tgz"
  sha256 "9f15ba22bc40b0443e4036f05381b5e1ca4fdb6822f7fd734b4258c2a97bdc29"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "2176eb19ac951ae21dad44edc501273cd47e5a440d7282e97c48c959f3a80e1d"
    sha256                               arm64_sonoma:  "2176eb19ac951ae21dad44edc501273cd47e5a440d7282e97c48c959f3a80e1d"
    sha256                               arm64_ventura: "2176eb19ac951ae21dad44edc501273cd47e5a440d7282e97c48c959f3a80e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0caa0e5650103baec8449f76694f13dd76fdeabccac2b7a62cfbde6ba1d4e794"
    sha256 cellar: :any_skip_relocation, ventura:       "0caa0e5650103baec8449f76694f13dd76fdeabccac2b7a62cfbde6ba1d4e794"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbe2c9e295979b8700244077f6367e52c86adeb45fb35d3539aa5f6a4a17bcd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e43a3295383858a40b9da62f6ceb932e1f27fd0523ec7cdefc0b1d3cc77e546"
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