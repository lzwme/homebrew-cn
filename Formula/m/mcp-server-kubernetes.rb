class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.9.0.tgz"
  sha256 "c1db002881d13bd0c68d90e7c01874c9b170b622c58ad78f0c14286bb53c91d7"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "619d3f7d12638da88f7bc46382ebee0cdd78b81c7c5e7fe745228909c64972ba"
    sha256 cellar: :any, arm64_sequoia: "80c9fe3a7580684bb5fd9bb929b8648c44e977df11fa5d4ef88b238ce0af40c2"
    sha256 cellar: :any, arm64_sonoma:  "80c9fe3a7580684bb5fd9bb929b8648c44e977df11fa5d4ef88b238ce0af40c2"
    sha256 cellar: :any, sonoma:        "76d4ae0c7bd5edfea3165b4d9a2b0d80e8d88975479b52cb121bce7c2ffa492f"
    sha256 cellar: :any, arm64_linux:   "33a5623a834548157d6c95151b61ae43892dbf805c3effb214e8798385733a99"
    sha256 cellar: :any, x86_64_linux:  "e874a4fbde16f43e0f38dae80f984e33784a4de3d3f2b6314bab3c0d993886b2"
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