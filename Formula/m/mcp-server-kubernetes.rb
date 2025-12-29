class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.0.5.tgz"
  sha256 "b9f78669229dce20b48eca8b8f41b8ca35318474c5a790d60b2b9ff98a3126a2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4943c941a29ccf1518de4efa167e3c3a0dd2299af9d9405e3f51352c2d7e06d2"
    sha256 cellar: :any,                 arm64_sequoia: "7e475b6cc551a05e2c90ee9bb501cbd6b8ef62259d354106d4b8934e3f1b2d81"
    sha256 cellar: :any,                 arm64_sonoma:  "7e475b6cc551a05e2c90ee9bb501cbd6b8ef62259d354106d4b8934e3f1b2d81"
    sha256 cellar: :any,                 sonoma:        "9b6f42f581d55ddf6cc0f8c4d72fc9b7a43e271a60c20d054383e885b5e922b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "757b52c1ad35b3c9a23d112b3e1d3407fb415e13c3a5055e5fe0b212ace8af6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c212a760791455d57ebf3219b7e30caad6aa017df3f66849852cd23c8120670f"
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