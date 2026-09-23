class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.24.3.tgz"
  sha256 "116e7c65b851ff8d318c06b1eef1648815deac0c204e16977791de017c0165f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b63dbdff57c2b482f912654708742f343033f56e82c0c5a19ae80267624401ac"
    sha256 cellar: :any, arm64_tahoe:       "b63dbdff57c2b482f912654708742f343033f56e82c0c5a19ae80267624401ac"
    sha256 cellar: :any, arm64_sequoia:     "b63dbdff57c2b482f912654708742f343033f56e82c0c5a19ae80267624401ac"
    sha256 cellar: :any, arm64_linux:       "6e7437d66c33aa004083c47ef97463d0ecc7594d4f390ef5a81d64e6bbfd812c"
    sha256 cellar: :any, x86_64_linux:      "31a151b85510b09a5dfa23c910b48f95d7cdbabe2a97976f71a25fbb1be21ebe"
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