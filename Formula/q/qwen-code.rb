class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.6.tgz"
  sha256 "cd13343016960a1d20a501680c92c32b1097d83c5c8a2026ffbff752e7226e42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e873d037c3afd256f908c4c344272f7c955f4913ea27bce449298d2fbd78dfe0"
    sha256 cellar: :any, arm64_sequoia: "e873d037c3afd256f908c4c344272f7c955f4913ea27bce449298d2fbd78dfe0"
    sha256 cellar: :any, arm64_sonoma:  "e873d037c3afd256f908c4c344272f7c955f4913ea27bce449298d2fbd78dfe0"
    sha256 cellar: :any, sonoma:        "5c87a0724387a4f801c3d37fca78dcc0449f1f83bf55839a450a861a373a5d45"
    sha256 cellar: :any, arm64_linux:   "bfdb27c90d688c2e578569631dc329a7de49de1687a4fde7b480670cb0129693"
    sha256 cellar: :any, x86_64_linux:  "730ce885784d94f8bed5d1a93ca42904ec8f91682bb7870fc783d6e812aa0afa"
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

    qwen_code.glob("node_modules/@qwen-code/audio-capture/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end