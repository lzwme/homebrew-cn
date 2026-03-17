class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.12.5.tgz"
  sha256 "0af9f0f6e27a23d6d39da545ce6725a9d9a8250a6524c12768f8995b6506899e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ebad3495f53cf7ee4e83ebdf4c541ace8f719bb691cc3a09bb479281d0d0174a"
    sha256 cellar: :any,                 arm64_sequoia: "353bfed4d9e8fefa5baef8365ff1756baad1c9eb4ce9a05fb48f371a35d12c1f"
    sha256 cellar: :any,                 arm64_sonoma:  "353bfed4d9e8fefa5baef8365ff1756baad1c9eb4ce9a05fb48f371a35d12c1f"
    sha256 cellar: :any,                 sonoma:        "7b6f74dcf2326272294b5275d7761930659b127148aacff3a39e1d1eab87819a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e04e2725cc0ec11fd57d6a8e2ff7dc01ce275197e7d99d5813ebea7a59a84f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "203eb708bf96eeba5fb5bf1e2beccc26d2609da1c0c86f3491377565b1743d75"
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