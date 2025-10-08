class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.17.5.tgz"
  sha256 "f6475ac20e01ff7ce4c62b54c07f44574413f9268d560abe30629de3253caf3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "382b92206b4725dcbfea62d4363d9cf19288edb4f780705915ba1d48a46c272a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dcf09423669946a03cb3dda930770e62b2ab8ffc221fd95986c9f4056509456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0861c5809e79c07dc8b66c3046ed503ddcf14d05ef61e40fd5851ae4823c399c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ffcdeec9a667d4d3877e0d020ce80d239634f9208fd0ef2143f0db425c5c1c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78451b8a8046e66eb542ee48d359b83931cdcd7ab849eb0093eaed9c5362d3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11d2380ec7efe96a9aac9277b032d1a89cdea022429db8c19626f3987315fc6d"
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