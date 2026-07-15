class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.0.2.tgz"
  sha256 "cee6b951274182d2ab26d7775a0fe50c466999c0e9dd66da75e1c9db356ebc1c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b0ae0aa7c437f244b945fd56b9373b2ef8e83163ca9fefa0165b574a97723a1c"
    sha256 cellar: :any, arm64_sequoia: "b0ae0aa7c437f244b945fd56b9373b2ef8e83163ca9fefa0165b574a97723a1c"
    sha256 cellar: :any, arm64_sonoma:  "b0ae0aa7c437f244b945fd56b9373b2ef8e83163ca9fefa0165b574a97723a1c"
    sha256 cellar: :any, sonoma:        "1f74ee6473971de48738c033418de9221fca666f71dd0ba30dd5b2618ed11632"
    sha256 cellar: :any, arm64_linux:   "2340c61513b2b171c1677a6608df9c6a476c5daab506034a04f19e954a6b2834"
    sha256 cellar: :any, x86_64_linux:  "4d280e41d2b1df0145dcc768fe96b91417935ce8e32272dea1b6edd956e6acee"
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