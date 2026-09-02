class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.1.6.tgz"
  sha256 "86687e35f12906ccb67b26ec378bc0475080a27480575f1370e881b265f9bb65"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "de89dd90c2c3646e2157ff1f49736dde39301c6542f21d5756baf764c07f478f"
    sha256 cellar: :any, arm64_sequoia: "de89dd90c2c3646e2157ff1f49736dde39301c6542f21d5756baf764c07f478f"
    sha256 cellar: :any, arm64_sonoma:  "de89dd90c2c3646e2157ff1f49736dde39301c6542f21d5756baf764c07f478f"
    sha256 cellar: :any, arm64_linux:   "5f2e49efdd80e743bfb9fe8e1d092c1c0389c689657fe93e1a4ee80cf3119caf"
    sha256 cellar: :any, x86_64_linux:  "42d3770969776b9106386d6e40ba7306f7fdd675973e62b6c8f84d80cc4f46c2"
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