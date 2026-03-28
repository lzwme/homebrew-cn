class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.13.1.tgz"
  sha256 "64ddd6df824c39cd89ee91e2b3cbde607ed89f47984fdffdb96e81c3364381d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "effedbd6e36f6611c0aadf77ccabd6bf623b5045ee202fe70421bbf94874be8b"
    sha256 cellar: :any,                 arm64_sequoia: "68bcb4ecb255ab633a2ae83b58e6c174dca880f7c179e9398dc0d4cdd8f63eea"
    sha256 cellar: :any,                 arm64_sonoma:  "68bcb4ecb255ab633a2ae83b58e6c174dca880f7c179e9398dc0d4cdd8f63eea"
    sha256 cellar: :any,                 sonoma:        "ecd1a37b1ace35bf545d0fcf69a7c0e49e83c17a2aa9e5701965100b6ad14376"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ebf6d11af5baffbae1f4fdf443b73969a36f0459ac9e881c5fcd01dcc350e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29dc2ee9f3528db0847d62da7ca6abd6c41deb9657df0c1c5cae102872b3da21"
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