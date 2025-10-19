class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.20.2.tgz"
  sha256 "ae2ecc64c89c3cdc39bf5ac6d03b286156257f590d11e1c4fb296b2442e4083d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e16477ac71d0a13622f2b540febfc21fe63fe1d34a95d3d5cd564ca6144443d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c02a67a8c911d93df53883830bd6bfc3f8b15e7f3139bf32e93dc7baa59f5924"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27060434207e1e5697bea4e567f1e02f1721b3e65351cd8c13097208c54586d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e573a4e6d47545d17682e78e50f908dac2c7a2ea95c45ac253ca92d0dea34cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a5b429557176fcce12b6a4c2af4a9654ba705c27abb36308824f9191bb94579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23cf21328b16af604f0709767346c22ad9b2b835c0895b5b097c957d7e871506"
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