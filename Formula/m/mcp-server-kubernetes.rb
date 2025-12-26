class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.0.4.tgz"
  sha256 "7a67216973a9a41a3d1722ae03a9f1bfcea322f6d2c90a06022a95e591a24e0b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0c71c9a13e7dd7acd393b2f5ea2cc3e571f635b64f8f7c55068f668d3403a4f"
    sha256 cellar: :any,                 arm64_sequoia: "d3be9179437a77519a9350ca91e46b9147a757df3916c44c5fc0e457e9540b27"
    sha256 cellar: :any,                 arm64_sonoma:  "d3be9179437a77519a9350ca91e46b9147a757df3916c44c5fc0e457e9540b27"
    sha256 cellar: :any,                 sonoma:        "ac704ecbbfbf763a5841a6f2a34539bad1c8c74225f18d54b6f9534761053768"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06ac5b4f1409b23cbd0b4c9f487c8f7a96515b7b303570be3f8e4eb14752c9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e42b9890807bfae38ad3ea9b592cda400d9b31965b5d6b70e4a46f82e3dcf0a"
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