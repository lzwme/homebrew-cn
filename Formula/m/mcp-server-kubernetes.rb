class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.0.1.tgz"
  sha256 "b85f48ce42e980d0dfb48a971ba7f56c646ac70df63deaf5d15b138868b84b66"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5a7cda742e27865eac9c251ea6893875d538270a6f58f1b5f90ed18eb073ed2"
    sha256 cellar: :any,                 arm64_sequoia: "1640d4eb5023441235aea8211ded706e20bdde07ce3816ba5428fab34212d8a6"
    sha256 cellar: :any,                 arm64_sonoma:  "1640d4eb5023441235aea8211ded706e20bdde07ce3816ba5428fab34212d8a6"
    sha256 cellar: :any,                 sonoma:        "ebbbe7bb74acbc7be2dd53ef463b9d76b8dad6d35cbf4d92a59edf64e9fdd088"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "974d82c9f97ebef8de1d75f14d6bf40d1caf15c74f82ca79cb22af4d154d96ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08ae58f36aabfffa45e6e6dc63cff5d30b0db38faea76292be98e1a6fa84996b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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