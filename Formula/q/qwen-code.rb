class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.12.1.tgz"
  sha256 "26073fb4bd83e62e2ffb90ad36bcb72ad67c19cae7ad0a1b2d09ce9fcf71132e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f3753897a0a45f216fa9cac100f179eb237293a4240b3353f98c62bf43aa4aa4"
    sha256 cellar: :any,                 arm64_sequoia: "c1809e694827e6a3daad47c978b420af01bb55d81f37f39b20d75ae84afe2432"
    sha256 cellar: :any,                 arm64_sonoma:  "c1809e694827e6a3daad47c978b420af01bb55d81f37f39b20d75ae84afe2432"
    sha256 cellar: :any,                 sonoma:        "64d6aea9bcd19fa2b2346174ec53a2cee817a787d5b20adf88dbfb9c349b68d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7b2af69adde7d4e5c01dd981846fcf2378f7709c2f32acb6ee9298b3e90a3f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "603080d95a2f41e02ba1118a18515056f811c19d468365aa9fcbd4e8591225fe"
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