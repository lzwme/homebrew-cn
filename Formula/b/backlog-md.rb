class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.7.0.tgz"
  sha256 "2d778b3752f7ae9574ad95fb10e29d70666dd20e0b143dc4a27d6528ded8a1d3"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "b6eecba467aa74e61b3b870056ce5ea6dac5f308ce3755ce20933e90f94f6c4e"
    sha256                               arm64_sonoma:  "b6eecba467aa74e61b3b870056ce5ea6dac5f308ce3755ce20933e90f94f6c4e"
    sha256                               arm64_ventura: "b6eecba467aa74e61b3b870056ce5ea6dac5f308ce3755ce20933e90f94f6c4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "df45a65579b6712462cb36d091330c7de8f6021577d509aa274dd3999490cb55"
    sha256 cellar: :any_skip_relocation, ventura:       "df45a65579b6712462cb36d091330c7de8f6021577d509aa274dd3999490cb55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d51aecdbe8957cb3abb373f258f20e03cbb6eff2f1e36139955de452e7591bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6266248b4250d7edfa7fff0afb6cbe231c1f7b91505ca60786190e2ce0ae2ca"
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