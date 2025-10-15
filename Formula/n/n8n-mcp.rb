class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.19.6.tgz"
  sha256 "c616452bf65a40a0617ffe986b333a00d2db7c1bf8d4c8044e26b6089e8220c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afe7d483be9ff2ecfe9b3703766f3dbd6f5c3aada7b94269be823896d14ca9ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e99ebbbd23c0117ca7d537297abd053b8bdf6fdff628b9b09a73ee3c5c5c744"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a38ed81d772174c9f7c6e70182073f80f1b407d6a142bb1b7c9a8ceb2e1af9b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "6307d2a671dd591b800d715db5b2a5fc39dc8cd388e2c6cce61e395ccb0d329b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc8328e9e01abbf8ff5440c93d5d6f949c662e471ba2c52551e2d1c8733461bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5ff00fa262389a2c27d94cc04ce3c45ab8dbf55896dcb76655386f5e6f027a3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["N8N_API_URL"] = "https://your-n8n-instance.com"
    ENV["N8N_API_KEY"] = "your-api-key"

    output_log = testpath/"output.log"
    pid = spawn bin/"n8n-mcp", testpath, [:out, :err] => output_log.to_s
    sleep 10
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_match "n8n Documentation MCP Server running on stdio transport", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end