class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.15.0.tgz"
  sha256 "944af91c017a938b3807d240f55f333a774f344cd9e5e9749f3e259f5df729a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d162993e540e544c744c6de13173a9ba59ce448565b750278bfa410dadc21730"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d162993e540e544c744c6de13173a9ba59ce448565b750278bfa410dadc21730"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d162993e540e544c744c6de13173a9ba59ce448565b750278bfa410dadc21730"
    sha256 cellar: :any_skip_relocation, sonoma:        "27c338945c6ada9e9d6aa6659a289a093c86d8aadc0af8762862ac77ec2ee864"
    sha256 cellar: :any_skip_relocation, ventura:       "27c338945c6ada9e9d6aa6659a289a093c86d8aadc0af8762862ac77ec2ee864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d162993e540e544c744c6de13173a9ba59ce448565b750278bfa410dadc21730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d162993e540e544c744c6de13173a9ba59ce448565b750278bfa410dadc21730"
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