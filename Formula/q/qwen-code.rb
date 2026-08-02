class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.2.tgz"
  sha256 "3b0ba88fbb5c7d93b20e8f9512f21eff0351b5eaf95f8fa11026be00a7e8ae29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fdf084409c9d37553a10294526ea52317e4b6099286bc35043765df590527f6c"
    sha256 cellar: :any, arm64_sequoia: "fdf084409c9d37553a10294526ea52317e4b6099286bc35043765df590527f6c"
    sha256 cellar: :any, arm64_sonoma:  "fdf084409c9d37553a10294526ea52317e4b6099286bc35043765df590527f6c"
    sha256 cellar: :any, sonoma:        "0f4f30575c4bd0141e9b841c12b758901b749f71addd9bee4aacc4f4f7b345a2"
    sha256 cellar: :any, arm64_linux:   "516c8f73021eb539dff30a4a29c574b74b747e3fe829fcc7654d8f7e46ac2810"
    sha256 cellar: :any, x86_64_linux:  "1010d21b0b9a30ebd01095a356941606f7c343952f8c9e852f2282b0427daed5"
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