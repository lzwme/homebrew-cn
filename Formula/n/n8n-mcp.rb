class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.15.tgz"
  sha256 "ed56d40c5e96c7296fa75586ca67a081a58c89a2324d9ce52d396a930b83bd24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2228d6a4f03832cab533dfd935147b62415a8e53642cea76d9e8b887e0bdc331"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190fb171d52dd0eac08c86a931b54b504336de04d12ada22b97b114ff13b7a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ded72c1788a0e1b7da6dd20aaa7e4cf90d5f736500724b74c14da159b4a49514"
    sha256 cellar: :any_skip_relocation, sonoma:        "f254122494ad241fe7412370236f3ee8815c4641a9d6d211e976ce37704f56a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa45638a26981623a0bddab753ac2e496f4ab07b9459f63d383f05be05a0aaa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "812489cd10be730e2f3438bd53d979f7ce13b36c43b1d4c38586acb41292380e"
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