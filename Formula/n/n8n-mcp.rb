class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.6.tgz"
  sha256 "e6d478e7858b4d6a184ea2814d8c759a0ce1f835e09ea4848e8dc4f242acbf1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43bc1496748c39225eeaaf97c9ec0530901544fe9fa017dd9d2af4d7cdb071e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f1b8a433db2d9a295fc0203085120b978fe84774bd368b433f56aec0679fbf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0235bf5cdebf0c6762a302a5318695bc06ff49f6b59a148edb039b2f978172e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f51261c0b2c7289974bd523630eeaaaac2a2b91239bd135e3d98e85b39455d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a397516fc6df083a11b0974db78a3c6bc109f106169909e4dee3bf382179fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5bf6456d70899e8c15014c8a237eecbb485efc3f0628eb54c38851dfcc4ce40"
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