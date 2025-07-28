class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.6.3.tgz"
  sha256 "81fc25ef128282dae4f7ee3cf777cd1b047acc5139bdd9c290a7f01b29c0cfc6"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "4c84c0b05b39eefb3bfe9601d4e1ba9568dc7fa513a936204311ff70284a0435"
    sha256                               arm64_sonoma:  "4c84c0b05b39eefb3bfe9601d4e1ba9568dc7fa513a936204311ff70284a0435"
    sha256                               arm64_ventura: "4c84c0b05b39eefb3bfe9601d4e1ba9568dc7fa513a936204311ff70284a0435"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f710c299b2cec1203cc42521a1d806b7ed2ffe3663dc4c4baf35987bbedd3be"
    sha256 cellar: :any_skip_relocation, ventura:       "1f710c299b2cec1203cc42521a1d806b7ed2ffe3663dc4c4baf35987bbedd3be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f35b21b0b09fcebda2fb1e262454824d12cb5bafd591ae6093f29ab16b2906a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "411a07c0be8c7f8dd543933fbac792ff34f13f045ebf940057b279b54ad0daf5"
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