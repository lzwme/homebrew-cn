class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.4.0.tgz"
  sha256 "fdc8448856e2e5e23c9d141d1cc6aa823b7b6cc6721dd9a31d22435751f64d63"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "168bcd71f2d36cbf73ff8c851eb05e4aa8e1c7efb64d64425a5083c1aeb5d37b"
    sha256 cellar: :any,                 arm64_sequoia: "061eda4cc8ba769c110cd47cec8cf6f627b9b076e780b2a5988db7dcfa0bc2c0"
    sha256 cellar: :any,                 arm64_sonoma:  "061eda4cc8ba769c110cd47cec8cf6f627b9b076e780b2a5988db7dcfa0bc2c0"
    sha256 cellar: :any,                 sonoma:        "d5b0e727a31e71db83021dfce3d3d5d4db3a77ff49a131c8442d5154a787886c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e88c1b5478c33f1b9b5ba41e129d465a027b82dc6b17ff86bb0eda9fd17a5a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c04500b78fea05dfd398d05cf4b2078b4b348e4aa847a8cd5255328e0f6726dc"
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