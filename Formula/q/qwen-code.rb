class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.11.0.tgz"
  sha256 "247dca4266570a82bb51010fb4fa59bec25e2b96d680d653b61ea0f3ed9fca55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0552f24c0eaf5b5738fbf8eab8334257fb929d1cb4764f20930867277c1e3108"
    sha256 cellar: :any,                 arm64_sequoia: "2524a9e6ed3478bb7c5c1523492f78ea7f64161cdd7ff52bdfe37f966c4f88c4"
    sha256 cellar: :any,                 arm64_sonoma:  "2524a9e6ed3478bb7c5c1523492f78ea7f64161cdd7ff52bdfe37f966c4f88c4"
    sha256 cellar: :any,                 sonoma:        "fc2f96fd363199912f9c37324a4e99db3a7d11142ef5ba5ff5a1e6988bdecb88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1afbdaca710402142f1d8533bed2104d9a3d7a7fddd0b9c9aebb8807909cdbd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b5e81dc43838a3e58e55a316b11cd0a64494af7c08f63b29e8f6362ca8e6c88"
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