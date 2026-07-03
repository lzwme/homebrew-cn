class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.4.tgz"
  sha256 "0040bbaa7c741eda41bb7b21ab52c1bb783450dd33f1aeb1860d9d7eb2cd0716"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "691e0a7a129fdf7ba584d3304ceb0fbd8f07ec967da4066648b3dd4bbfba58fb"
    sha256 cellar: :any,                 arm64_sequoia: "009bc14ad15158afdeb683a21707861763dc9ae5597fca1a877c67dbe6b93fc3"
    sha256 cellar: :any,                 arm64_sonoma:  "009bc14ad15158afdeb683a21707861763dc9ae5597fca1a877c67dbe6b93fc3"
    sha256 cellar: :any,                 sonoma:        "4cfb6be0109f92ad2d1d5703814cf5480405f6183857824724ce3d3e55d05ffa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da411ffcfa26d04f2d3ed0c4c6ecd130690b5718bd7947c129d6d2a447d659e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05e355bc9fd682c75e69b37be2f94d776cfcbe83f78c4da641195a3f31d2c22"
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