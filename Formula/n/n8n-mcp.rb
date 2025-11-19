class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.19.tgz"
  sha256 "b929993cc710fbf4d74c19c236617d06c8f036823c2d96dee535aea52e97f3b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52cbeb22f21180829d49d02804ff4d8160c060c7ef105be6789296c341a30bea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c83a53a8deede38248f02affdd74b17136b2d3129938d805abd63c8f7183c1de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a9b6e64ded28cfb0a90fa7f70c6459f05116c87e289c6ecb850d88497369d31"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0d02e9624b7d42e2a673a427fe868b75d47a91aaa7d591ed9e6eb0291b3fdb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8e19011d3798685de02dbe242b2611ca37cfe374f4940eaccbf5b75dfad5b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c733adbc3079bbdd6ddd575dafb7d2583fb3900addefaa46e5b1c90ab017c2d9"
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