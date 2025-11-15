class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.18.tgz"
  sha256 "53c40bfee17741d0c3848d1d2da143b9917b828b9e5fef27a3e59025a02f3207"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef18188233d5a69465b35e348ec7aaed60639badc936bdffd2233d06ab3993ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de0f2918a86cd8b398ad329a538c94e741b2f5e0397f07e0f5297295afb52325"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4e2a5993f089312f97f5897383edfe19b087c74c0353dd4870d8b77846aade4"
    sha256 cellar: :any_skip_relocation, sonoma:        "49b56df35459f870b699d38b7050e854e32f7f35be7b007779d4d8a4559086c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3cfcdc937c7ad35526778342b2a4dff16f8da80478044b8f14d0cf785f09ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fc7f1ba1222266e16340d893bfd07739ac4a461ac48573db1cb023eab407125"
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