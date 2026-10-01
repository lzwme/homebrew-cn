class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.1.8.tgz"
  sha256 "8d26166fe71dfe544cf8120e63c90b0430c2aead81dd67913527b5cdea13b252"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c2f58adc8fa16b55f79d9b88e0d91197c38bc0b503037e9607cbda07112b9242"
    sha256 cellar: :any, arm64_tahoe:       "c2f58adc8fa16b55f79d9b88e0d91197c38bc0b503037e9607cbda07112b9242"
    sha256 cellar: :any, arm64_sequoia:     "c2f58adc8fa16b55f79d9b88e0d91197c38bc0b503037e9607cbda07112b9242"
    sha256 cellar: :any, arm64_linux:       "dd156b02f6274906e3d464e65e14ee69dd3fe61e7e6825538c066af1af2e203b"
    sha256 cellar: :any, x86_64_linux:      "2bfde1446d582737cdda2464ffa93958c9234e77e672d8704ab6e8f9209222be"
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