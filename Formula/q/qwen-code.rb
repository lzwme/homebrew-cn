class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.8.tgz"
  sha256 "fec561a4895e0ec560649da89e4369ee18a10000f62c71e885baf14eb58f8e55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c01895de8e006975f9565de5237bfe848e4a0342e5d04d804ce683c4c8487d7"
    sha256 cellar: :any,                 arm64_sequoia: "b55838da9bff6956892a584180218b5adf52b97f61dcd46355b362f9bc629b1b"
    sha256 cellar: :any,                 arm64_sonoma:  "b55838da9bff6956892a584180218b5adf52b97f61dcd46355b362f9bc629b1b"
    sha256 cellar: :any,                 sonoma:        "5a8abeb4a846db12b8206404088dbeeea237452ae297a2ce892376fcb3a0593e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e3b929a49cab607395421a36ba262833169e5b1f69baff62e0008872c86ae5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0421c534ecba976794d62aa2981b718dda05e2134c5a5cb9291c84479803d354"
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