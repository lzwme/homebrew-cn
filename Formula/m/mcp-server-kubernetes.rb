class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-3.0.3.tgz"
  sha256 "4a754822eceeb4ab6abe7c2a61b718f2fcf0c97b0417683e322230d285af18e7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9cde7e5e76f739eedcc1afc16fd79452c60d9a986bf655b56d295cc4546c2c1"
    sha256 cellar: :any,                 arm64_sequoia: "f4250c7cc1f08d25329565c52b9991995f0ab9c321861d6c455b994381a5238a"
    sha256 cellar: :any,                 arm64_sonoma:  "f4250c7cc1f08d25329565c52b9991995f0ab9c321861d6c455b994381a5238a"
    sha256 cellar: :any,                 sonoma:        "d424385fd42d3d539ecbc40f0093e6814461c28c55b189069e5296de5278f09b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9b70c68ac633a5b900399fd804db37a3793185454f2393e66e5f95f8b335aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b316726f2b7671d2438b33890b25b42c0cc253c80565f927f493993151faebe0"
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