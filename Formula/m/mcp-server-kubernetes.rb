class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.0.1.tgz"
  sha256 "5c8c338a3020a8c4fca5e803aa9b84e9b03951a9a6420b8da45037aa263a9c51"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8733151a544f7a676908c5c3ca148874a5982151987c9e59e2771a6172f29b6b"
    sha256 cellar: :any, arm64_sequoia: "20cae8f7e3672054f911c147b5ee4753bb959e08dabe94f762b1c435b0ad77b8"
    sha256 cellar: :any, arm64_sonoma:  "20cae8f7e3672054f911c147b5ee4753bb959e08dabe94f762b1c435b0ad77b8"
    sha256 cellar: :any, sonoma:        "efaa573d283e7e35af6ba231d9ee4551490da3832a2535714bb1d8bd0b9b8cf8"
    sha256 cellar: :any, arm64_linux:   "1383c5f9f0bf05de40ee5fd8c93a6cbd5a0a7669604709e6f5b1c0d63102baab"
    sha256 cellar: :any, x86_64_linux:  "7aec098b68a44a0439b8397012f53b37a03d6dfbde9fb9b1d299703745f74656"
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