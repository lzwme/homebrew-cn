class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.16.tgz"
  sha256 "1bda88490795196d9d31454cde2d34fbad6d43555858aafc0296c56f7a1bfe1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30aa005db8d8a0a94b3f0c89695db6cecbc83c9f308a5de4b1addf3b1b5776f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ed36bd9d6fa3580ca8fb89289772e32f1bdb6d97606ddcbd9d34b2570eed913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89a066404974460cc9d826677b65de8afb5ce21d45c26b673a16d48dd641e389"
    sha256 cellar: :any_skip_relocation, sonoma:        "aab8aba2393c508535f77c153aa9345bc7ccff47c8620f6a2375d43a781ecb0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b6ffc7c41352c49d2e21b9343f9b1c784cc4734c267ab2d4d17e19fb25968ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f1edbef3923f4bfdf0cd0fd26cb1716c36b2d5415c25d18aeb0bde5584ffd11"
  end

  depends_on "node@22"

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