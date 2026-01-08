class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.1.0.tgz"
  sha256 "1508da1715db71f57a4369d2f751e2b150a40944ea6d8079acae1c28043c828d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f81e3759b48d8c25593e049393309de7a2d0c5259cbb5a60cbcae0967d720f02"
    sha256 cellar: :any,                 arm64_sequoia: "f759f44feb0aab4f4d598edc3c427a40faf6a019d3db80c6008d255ddb4f9e55"
    sha256 cellar: :any,                 arm64_sonoma:  "f759f44feb0aab4f4d598edc3c427a40faf6a019d3db80c6008d255ddb4f9e55"
    sha256 cellar: :any,                 sonoma:        "ac094376ec28f6ecbecb0bd18f52a2bcd8da904b4e2deb8d612b7861e2903872"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d07a68526a3a7879fee246018a3e57e99bf844d1a65d4341419ee6f4668eed20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0203fcf2d0a517bcad72b5f684b13e55fa7cecc48337e91bba57f768830ce0e"
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