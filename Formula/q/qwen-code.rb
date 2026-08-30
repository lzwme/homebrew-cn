class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.22.3.tgz"
  sha256 "2521d3ef3a1ffc21f6c876218922f628ea8bce4ea290d8d2a752e7085089ea9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "600de22ff320069c2b656b25e657e0684277131e488cac4c4ae05a1c6026806c"
    sha256 cellar: :any, arm64_sequoia: "600de22ff320069c2b656b25e657e0684277131e488cac4c4ae05a1c6026806c"
    sha256 cellar: :any, arm64_sonoma:  "600de22ff320069c2b656b25e657e0684277131e488cac4c4ae05a1c6026806c"
    sha256 cellar: :any, arm64_linux:   "86aad1a6e564aca724281578468152002c885a5faca855689640d30235c1935b"
    sha256 cellar: :any, x86_64_linux:  "eea93b495469591fb002bb09b9832affa4260b5d278595f293952a533e3a56b5"
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