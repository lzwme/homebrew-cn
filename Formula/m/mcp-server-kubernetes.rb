class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.0.2.tgz"
  sha256 "3dd851786142a7c7b7ae091716541da9f9073e8b7c19ca5d2e8f27ff2f7f12ba"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9c2f9e45525e262ecc8fa474e87ffb5b3e08b621b7eca418c995a01ff16946d"
    sha256 cellar: :any,                 arm64_sequoia: "0d557813035cd304596aa09eba4bf4cd864a3c0ac75da7e3bb6f7c6e08e4683d"
    sha256 cellar: :any,                 arm64_sonoma:  "0d557813035cd304596aa09eba4bf4cd864a3c0ac75da7e3bb6f7c6e08e4683d"
    sha256 cellar: :any,                 sonoma:        "b9725c6a92c5190582b0cc4a62c253b3e53541457131846a4a5af18b0dc16c1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98ee04c8a8afae6544cca61f8e07b51f5e1bab6c2f4b4e6dc53a87c498798eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93f0bf33af5fb320692bcfc470f376c2e7dc5e93e0d519465d7abbfbc271bfd"
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