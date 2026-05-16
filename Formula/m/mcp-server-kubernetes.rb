class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.6.2.tgz"
  sha256 "bb420fbdaf5c7d10505c5c5636b3890123b01ed5c71b97e1206a361c14fd6410"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "748ad111aee5a692a063a8e90e499a9a7d58bc1c812272b65e33e219d98d7f4e"
    sha256 cellar: :any,                 arm64_sequoia: "11ae541cd027de987abc4f704c3bb204d6868ff4c93d4c0e51ae15260ddb9bf6"
    sha256 cellar: :any,                 arm64_sonoma:  "11ae541cd027de987abc4f704c3bb204d6868ff4c93d4c0e51ae15260ddb9bf6"
    sha256 cellar: :any,                 sonoma:        "ba9fa5719830073fb5f4211d0c6a6d99ed693fff5d3e13819b2ad69787d475f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8026dba7eecb7667104dbb95ea72e1d72d37a10397732f9246fdcc4db091806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5416936d6c48ae248579e890f067a268f51636d12a9271a4dc10d78707e01bf"
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