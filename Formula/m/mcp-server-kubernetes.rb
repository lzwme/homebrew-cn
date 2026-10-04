class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.1.9.tgz"
  sha256 "81dd4fcbabe7fe822a9d7dc45b80bf5545ea31ddc8d89b070cac0b64a2640350"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "847809f738fce8265864270f6b0a31ce24cb54b77f465f32dca84491f24c7ec1"
    sha256 cellar: :any, arm64_tahoe:       "847809f738fce8265864270f6b0a31ce24cb54b77f465f32dca84491f24c7ec1"
    sha256 cellar: :any, arm64_sequoia:     "847809f738fce8265864270f6b0a31ce24cb54b77f465f32dca84491f24c7ec1"
    sha256 cellar: :any, arm64_linux:       "535513b6f2dcf0c7655075a6b71c69058415546b48d8f3ade20a3d46053f2980"
    sha256 cellar: :any, x86_64_linux:      "bca5f31c42a1eaf2f708e2864c8585e8f7cb5fba6e030880a81b314d076daa88"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
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