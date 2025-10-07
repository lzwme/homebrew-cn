class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.16.1.tgz"
  sha256 "873d5ba3f2a597ffa9c461675bbb3838e6a6f60425bab3fd310ad8bd5a127fd8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdab669e2572ab370c01e67539122cda9f2c59c05cbf14fc16ece15857549571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dab01d0229c439d8693eeedd106b40a96c546e97a44d6d6c2d1d91c481ea3893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66ffe5a5e2a60deadabe3de419802e10272793cb937de54c8ae7131e729c12e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3543260893263258bed3a4b67d05f1752cd0c3f126592da07756a4d26802659c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20f4b243e1041c4d3899f45cb71106eb0c5df94121a3ba603dddec91e9e9c3cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6861b52bb9eb63f1e40a93ad229c987806fe4a93571d7342a48880a59f95da50"
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