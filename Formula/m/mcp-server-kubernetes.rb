class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.1.2.tgz"
  sha256 "d550e0bc2bb0b459714a963d3232db1ab7b683424b9f079d83bd2fd0ff979797"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7ca58aeb4c04d0f81e0efb17e1ab09c57ad9f887302e181647be0667bad6da14"
    sha256 cellar: :any, arm64_sequoia: "7ca58aeb4c04d0f81e0efb17e1ab09c57ad9f887302e181647be0667bad6da14"
    sha256 cellar: :any, arm64_sonoma:  "7ca58aeb4c04d0f81e0efb17e1ab09c57ad9f887302e181647be0667bad6da14"
    sha256 cellar: :any, sonoma:        "e7094e19f672722d818c2735840cd1d7640fc07e0b76a0398860edf26945d4a0"
    sha256 cellar: :any, arm64_linux:   "8b1754d890e9937122fb9ac83f412b2ed56026fdceca03e0def131075b62d1de"
    sha256 cellar: :any, x86_64_linux:  "6866bb96c1918ea931b609be85bf59ae997fea85f9ed93423b17f1214c2e7553"
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