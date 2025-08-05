class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.7.1.tgz"
  sha256 "1c35ce8fadcb49e910b10181a411c3b5c08c22406e43d945cdf13e1c10a65cc8"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "38fc1cb29ba2769d75428acdb5129bad95bb23772e363d91183a93c69e85e159"
    sha256                               arm64_sonoma:  "38fc1cb29ba2769d75428acdb5129bad95bb23772e363d91183a93c69e85e159"
    sha256                               arm64_ventura: "38fc1cb29ba2769d75428acdb5129bad95bb23772e363d91183a93c69e85e159"
    sha256 cellar: :any_skip_relocation, sonoma:        "0155c1275f96bea832b218ddaaee5f1a6675986fbfe870e8b9a64df320a57ee3"
    sha256 cellar: :any_skip_relocation, ventura:       "0155c1275f96bea832b218ddaaee5f1a6675986fbfe870e8b9a64df320a57ee3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a457760c39c81b32fa5ee77dd66cd11439b7578c066e7619b79a2e20f907a8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ebce5f7eca6ca18a6b4952c44c3d34b20bb39e7bf102e65f705c7fe95def70b"
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