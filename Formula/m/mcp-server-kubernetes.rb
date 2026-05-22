class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.7.0.tgz"
  sha256 "f142866042a46ca12a03c73fd0bbc4e8dc8e6bfa0ae6eea37e89690487d06cae"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9caecd7304ee9bdcf2044a675bbb047f52f25366f8a5b134238fa5c3a4649a24"
    sha256 cellar: :any,                 arm64_sequoia: "432119ea06f974297e978531052337ba6aa0cbd0adb8e4372ff299b0287a4a80"
    sha256 cellar: :any,                 arm64_sonoma:  "432119ea06f974297e978531052337ba6aa0cbd0adb8e4372ff299b0287a4a80"
    sha256 cellar: :any,                 sonoma:        "880459c849dc4c175ae765da21f5975faa28cd014fc4e4066ca579264798919e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecda34fd769a615093fbb1d2f39066df3e695c806cb6dfce3d26b3a0edfe8069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32128909ff8094219c04e388a0ba9d857a911b82a6409d274b2df2bbb0b58a66"
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