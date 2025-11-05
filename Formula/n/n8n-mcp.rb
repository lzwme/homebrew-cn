class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.10.tgz"
  sha256 "38f0b3ba9d33fa205657fb971af91eadf14179748208aa1ba86bed193ad9dcbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d87605d7c611f3e8ba0ee14f07729d5a4e6042bccc49b93c22c8743de1304124"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aac1ddb4976c7c7678b5c7b0a2ac9e1eabcac32038631207fe812d7e884bf7c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c989caf861253b9346d888bdb8286c6622f5e86464a927ca25295f09e7b4740"
    sha256 cellar: :any_skip_relocation, sonoma:        "b95b376d78899fd59bffd0095f494adb94209cf13441d4ec47d54fcc55103a47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1942969fc3ed1d4522505bdf9c196b0ed655fe18dee2c0ccd017721bc65a3007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f96df49d9a926e663837ff50f51a3eaf03430c2b854095e0137464bbea1f3cd"
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