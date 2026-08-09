class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.1.3.tgz"
  sha256 "e877950de7711889ae93df98f2b9499734c60f24c71a8ca057756aa1eddcaf36"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f7d63083eb765fbafeab00d69df60f3320b6454b50392ec705ff2078f1ceb47d"
    sha256 cellar: :any, arm64_sequoia: "f7d63083eb765fbafeab00d69df60f3320b6454b50392ec705ff2078f1ceb47d"
    sha256 cellar: :any, arm64_sonoma:  "f7d63083eb765fbafeab00d69df60f3320b6454b50392ec705ff2078f1ceb47d"
    sha256 cellar: :any, sonoma:        "73ac7984689a04734665fa2e7237ad24eca8feb203ceac79d19ba9ba44a29042"
    sha256 cellar: :any, arm64_linux:   "95aa8b79b5b887f8722e6b4c8641c4a26b447f0cbbe56e6dbf7bea07375a5167"
    sha256 cellar: :any, x86_64_linux:  "3361d3c7d75c0e82df90ef20202090f5b7d1741138a0c391308c46b5b030b11a"
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