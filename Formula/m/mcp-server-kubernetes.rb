class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.1.1.tgz"
  sha256 "d52cba1429e4a4c2d307cd922616c27c8d2df7dfea69738407d94ff4c3484e79"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ced230fd07b0141d36a40b105982f1febd4de1e36e24fe2b6305cd16ea6a9e59"
    sha256 cellar: :any,                 arm64_sequoia: "25df6ff3dc5220200a4904008d02b28bbe6c31b2eae2c5b70d188d02738eee79"
    sha256 cellar: :any,                 arm64_sonoma:  "25df6ff3dc5220200a4904008d02b28bbe6c31b2eae2c5b70d188d02738eee79"
    sha256 cellar: :any,                 sonoma:        "5e4ec8a96e5fb9b4f3633b51a5934e940274ab8d5e125ab7e644f2cf34fd8c05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caaaedb1b33e17d81b0c90fcf9fe9bde8f8d813ea363d08c9abbf6aafb3e7e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1c4edcf1ec4156c928c32f63d73b9f1f6cc34fcb1f640f9d386dc9a49ad7df1"
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