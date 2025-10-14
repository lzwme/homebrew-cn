class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.19.5.tgz"
  sha256 "5306556f61454e0abf8aacd87b3f622927ccdbb1e068c2f518cd0fad2ae4546e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e8c324cebfbf3a0d7416172e451bc0fd529c2ec4c5dd74c7f64e87686715e27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "431abc3f8f665e3dc15b339372714611c5dfda9a937b9758dd1eccee3920d488"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "180362ea4e4839120c758086b6ea0a469906870eb64d3acf6e6b655088c3bd2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "84236c3aeae50d18b841c65033dbbd855fadb1c61dfabce67800f3dcd7423176"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1c5454a8d95a0408e927dcf7c86cbc9374fe821434650e37ea6377b668c3d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5e6be435595e89f8a43b814cabdb1bfc73f5b6e24132e143f5058acad625d4c"
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