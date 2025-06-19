class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.14.3.tgz"
  sha256 "403c0b277c400cc82abdf9d83381eafef9d2ee0a90ba8c7c7b7c714a820d2eba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a36c3e34f834dfed77d89954cfdd02cde892183b3c751505feb23208fa4b72d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a36c3e34f834dfed77d89954cfdd02cde892183b3c751505feb23208fa4b72d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a36c3e34f834dfed77d89954cfdd02cde892183b3c751505feb23208fa4b72d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8302b7b13196d83b351dfce81608c43640099a883026013e2443c685550e083f"
    sha256 cellar: :any_skip_relocation, ventura:       "8302b7b13196d83b351dfce81608c43640099a883026013e2443c685550e083f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a36c3e34f834dfed77d89954cfdd02cde892183b3c751505feb23208fa4b72d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a36c3e34f834dfed77d89954cfdd02cde892183b3c751505feb23208fa4b72d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end