class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.0.4.tgz"
  sha256 "4089393c53445d0e0cdc5463224d31b86b4a4059b7cf34ee2c1fa130c9b46d17"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0f21a29d6469a7f5e6991e51cefff4abdc5305a63d5e13c452015d82fc31a5b8"
    sha256 cellar: :any, arm64_sequoia: "0f21a29d6469a7f5e6991e51cefff4abdc5305a63d5e13c452015d82fc31a5b8"
    sha256 cellar: :any, arm64_sonoma:  "0f21a29d6469a7f5e6991e51cefff4abdc5305a63d5e13c452015d82fc31a5b8"
    sha256 cellar: :any, sonoma:        "345af889162654c7d7c573891b7b82f34de6c19a73e12decb5c9df33b8e002ce"
    sha256 cellar: :any, arm64_linux:   "3ce975e2c53da7c642e73edb74e924f2969851a2e3f6bba9ab7497524193442e"
    sha256 cellar: :any, x86_64_linux:  "b0dd0744203d726d64289b22c1a969a092d2da11e2ae820ddffdee6e5dc31311"
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