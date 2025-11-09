class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.13.tgz"
  sha256 "f08bdc7c3cbdd19ce633c3c3d596034b928fbb961768c2b5ea6577baf13ed6fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c5f6592440815660202db42cdd60c0fe7b13bbaa3dae6699eee81b9a553c5e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4bb83abba807538ddf01d5f9983ae30159888141a19c25830b3c9ed7057f603"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db168b839197c0533383bcf904f352ecf4ffe5b27b45060643345776b614c04a"
    sha256 cellar: :any_skip_relocation, sonoma:        "520cafb9924a6d249038a737acff064ede4845b02c344c6ec12b21dc351ba083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59dec541adc0972adac21004fdbe9cbac41622760e2bb4b3d6d43c8f04c99240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ce0132c68f8067aabd82496134bce4a61fca70208e3e154b6ee34202639d04"
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