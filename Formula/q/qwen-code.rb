class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.23.1.tgz"
  sha256 "7bdf1dd66d2510c4a4cf115ab3a98be2cd2212b76dc673bd3e25fca36e638bc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "655090c83c6a40cc73003800825ac62d1138b8c250f0a7ee7b68e80d4c394a44"
    sha256 cellar: :any, arm64_sequoia: "655090c83c6a40cc73003800825ac62d1138b8c250f0a7ee7b68e80d4c394a44"
    sha256 cellar: :any, arm64_sonoma:  "655090c83c6a40cc73003800825ac62d1138b8c250f0a7ee7b68e80d4c394a44"
    sha256 cellar: :any, arm64_linux:   "0c74757e9857765b476b1ffe37073e9c258c666a2977f3c7b2ff7f57f3afed02"
    sha256 cellar: :any, x86_64_linux:  "a8f3fb9ef925372e7cc4d4fba89aa7529da47584bfabd66b596657add0fa9e2a"
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