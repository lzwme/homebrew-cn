class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-2.9.1.tgz"
  sha256 "83dc88067745fe32791706babdaab7fd84d6a0a6a582dcb3a2904a20d8c35821"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f342dc47cd5cf5d0352cd5ae08724084e46ef5cf66853c19e0a4347b5c3886be"
    sha256 cellar: :any,                 arm64_sequoia: "01c1b8d088ab1f81a70a32430b73de370ade73a1b6334c67442dee809d7b81b3"
    sha256 cellar: :any,                 arm64_sonoma:  "01c1b8d088ab1f81a70a32430b73de370ade73a1b6334c67442dee809d7b81b3"
    sha256 cellar: :any,                 sonoma:        "ee42e958a37aac57e9f05d20ebfad1d4458ff9d89d2dfa804897c78300a84295"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c4a41385bcd6160896e04d2f1f5d06927995d899f4ee800fe2a2d414831d543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3827c8edb47573f4aba5aa72ad18b88bc42e6af7b79e8470b15d9c3f438dd6af"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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