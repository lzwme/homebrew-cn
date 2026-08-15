class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.11.tgz"
  sha256 "da76a1ce66ce2492ddd117666ed93621de689379e706636bc6204f4cc363144b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c3d6b6a90040ae2add7f7c8af5d8c6103a13cbff9156ae61762b8dca44186994"
    sha256 cellar: :any, arm64_sequoia: "c3d6b6a90040ae2add7f7c8af5d8c6103a13cbff9156ae61762b8dca44186994"
    sha256 cellar: :any, arm64_sonoma:  "c3d6b6a90040ae2add7f7c8af5d8c6103a13cbff9156ae61762b8dca44186994"
    sha256 cellar: :any, sonoma:        "6d4a4d391a0a2e5080c394312f64c1ab45defad9157da31c8a1522a440c3fd6e"
    sha256 cellar: :any, arm64_linux:   "6beedba50f5723eba3b117b7eed3e274d87ff8595be5285817367688ca3a087a"
    sha256 cellar: :any, x86_64_linux:  "2d9ef93879ec680dd6aeff504d6654f4c967dec01659c7f1f79e12a5a8dac29a"
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