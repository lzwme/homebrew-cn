class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.9.1.tgz"
  sha256 "49b240ecc2a533382dcd33067093ddf3292e075b01949ca2f3cd2f6a727b2454"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "af3fa32c5ec06512b8830b082c50c3a085b705e295c069daffc2905034ce8d35"
    sha256 cellar: :any, arm64_sequoia: "c4ffffb56ea49bd5d25f00082ef9a3f5a4f37942bbfb6868344ffeab3f74b425"
    sha256 cellar: :any, arm64_sonoma:  "c4ffffb56ea49bd5d25f00082ef9a3f5a4f37942bbfb6868344ffeab3f74b425"
    sha256 cellar: :any, sonoma:        "0cab46eb70b2ac1a4397ec177df5b41d90ff8112e84087af5fb78d7d25955533"
    sha256 cellar: :any, arm64_linux:   "d7cd4b5fe0c07da0b4e1f74e0642cd2051969f478bdbf0d137ae94d92c4c97ca"
    sha256 cellar: :any, x86_64_linux:  "dfdd80929c5ac4afaae2bb451db8b97b43d7f20b585595d029e75ee2d7c922b2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"mcp-server-kubernetes", json, 0)
    assert_match "kubectl_get", output
    assert_match "kubectl_describe", output
    assert_match "kubectl_logs", output
  end
end