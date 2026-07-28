class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.1.0.tgz"
  sha256 "c4bccd3af5824c27c9a9545c7526919939b143ff006d0a73696f7aca1dc13ecb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5dc05d133bf1e6a294bc35d509a1d8995bd2fb91139379a3ed24056fee5a4265"
    sha256 cellar: :any, arm64_sequoia: "5dc05d133bf1e6a294bc35d509a1d8995bd2fb91139379a3ed24056fee5a4265"
    sha256 cellar: :any, arm64_sonoma:  "5dc05d133bf1e6a294bc35d509a1d8995bd2fb91139379a3ed24056fee5a4265"
    sha256 cellar: :any, sonoma:        "fb394a2845ba35b59c2306fe7e2766a36312bb5e1f5a5449147ba098aa980699"
    sha256 cellar: :any, arm64_linux:   "eb66c9d7522e1c66d67837dff51a3f1082064deb36cf5c0cc3549cd1f32ca3b4"
    sha256 cellar: :any, x86_64_linux:  "337559767a9ea16cf896114c85c8cc1b3ff57ca4035d8d111b151689bf7c9a58"
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