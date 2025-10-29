class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.8.tgz"
  sha256 "796bc1a8505d56da90c3b3823d227fec57b6495bab4aa79d19091fb13d6572ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b905ee372343613fd16a67332798ecfbb5625f7f6810865811f997411ca0ec40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69f79e7234d6bf8a2ddb5f1ff2f21c9ee6531ef77db7fba4fa78881756899594"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a725fc5ce614ca5047184b4e70cf924d9beb82aa1e42e1ed0a9e0aa5dc9ce9ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5e778f79a697df82a40b37456ff5d908a11cdb60a6197a30e392ac9d253789d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81f8765a2c664b05b7efcee410a4a701c3e981067b2ee8dd1f3ed0fa74183151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60c4e5a62ef274eddb835668d32d1fc69491611729de8bcae2f5322e0d44eefc"
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