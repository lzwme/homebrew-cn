class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.0.9.tgz"
  sha256 "75805497a0330a53862089d481ef06187ab955a7231429cd135b532e4807906e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e02a8336c82ade34954953bad5e8bd78866d8825337df4c569e8f9bb93b300f9"
    sha256 cellar: :any, arm64_sequoia: "e02a8336c82ade34954953bad5e8bd78866d8825337df4c569e8f9bb93b300f9"
    sha256 cellar: :any, arm64_sonoma:  "e02a8336c82ade34954953bad5e8bd78866d8825337df4c569e8f9bb93b300f9"
    sha256 cellar: :any, sonoma:        "807f53e1a9c0b33e05819ea0139ff53890bfdccf6eff3531f594d7949ee4b810"
    sha256 cellar: :any, arm64_linux:   "4565a530ae5ac1dc80ee6a0c8362438ec55ac6685aa5439745a2bca2b4ec6257"
    sha256 cellar: :any, x86_64_linux:  "6919f2cec47e957f520eeb487a6a88b9e434a2c66a135437e8f5f2cfd94c7b59"
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