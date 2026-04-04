class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.14.0.tgz"
  sha256 "ceb11ad9e184e905c0d89f28ba75423d45c3e8fd14181ba99d73a56f11cb7638"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8153933398ab3c0d9d0c9e6fdd89f7ec96f793966d98bb50a821b41bc9dfcbee"
    sha256 cellar: :any,                 arm64_sequoia: "420710b06b450f2116054481779041de01f76a82eeea63432430a419ffcb6e4a"
    sha256 cellar: :any,                 arm64_sonoma:  "420710b06b450f2116054481779041de01f76a82eeea63432430a419ffcb6e4a"
    sha256 cellar: :any,                 sonoma:        "0809410f2a78bb133affbc4cd708a333c4d06b1a3eea11a666019ea9ef15e7ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f085da8aee613d3c00f3334fc283e9f8e3535ce8b8f4810c430877cf6e9c64c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79d8f20ed72ff78902133b9ced6b70b04e1a1a8bb0f553dcda9cb27767c216dc"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end