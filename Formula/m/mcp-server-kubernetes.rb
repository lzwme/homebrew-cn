class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.1.1.tgz"
  sha256 "740a294627c372fbcd53d3e9db4e04637abdb026fa16b6646a69cb39d398bd7f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b11b7c4576d91c58301898cf69ac0019883a09f12b9d135769ca9d6d4894a120"
    sha256 cellar: :any, arm64_sequoia: "b11b7c4576d91c58301898cf69ac0019883a09f12b9d135769ca9d6d4894a120"
    sha256 cellar: :any, arm64_sonoma:  "b11b7c4576d91c58301898cf69ac0019883a09f12b9d135769ca9d6d4894a120"
    sha256 cellar: :any, sonoma:        "cff2ac967247d544fda7b3f6836b40541bb4af37e1dd3c7cce92b4cf9cb258d1"
    sha256 cellar: :any, arm64_linux:   "1478e336ffa5fcb27c8dc0844ec2e5868b1006c2ccb26b2a379d7f87d7a96518"
    sha256 cellar: :any, x86_64_linux:  "acda68fd6f67e22b9c3404a6003632f3ad6b1e2a5eb7a9f989bb3a10d29007eb"
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