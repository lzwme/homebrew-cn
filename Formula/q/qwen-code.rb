class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.14.tgz"
  sha256 "ea865c120c3d73474f44e27fdc0bffc3ed21eb39403918def1c1a917fc1bc737"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "958c1083884ccb6aa2dfc67797c157f7ba8f3d6ca617849831fc8317bfa60177"
    sha256 cellar: :any, arm64_sequoia: "958c1083884ccb6aa2dfc67797c157f7ba8f3d6ca617849831fc8317bfa60177"
    sha256 cellar: :any, arm64_sonoma:  "958c1083884ccb6aa2dfc67797c157f7ba8f3d6ca617849831fc8317bfa60177"
    sha256 cellar: :any, sonoma:        "b03c3322c8791fa3b47b42a3961253a723be5d2108a1d2f11a7e830b617a8f42"
    sha256 cellar: :any, arm64_linux:   "2905439c48b7f6e92447c9d38b6bece70e272cd6e95cd0580b1f416223e627f0"
    sha256 cellar: :any, x86_64_linux:  "42f0c8097ca7a3ac3e10efd9a2eada8f876eb3aa835c809bf97fff0464e33e8f"
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