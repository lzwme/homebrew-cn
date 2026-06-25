class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.1.tgz"
  sha256 "7246af967e75719d08721c636102f5121f9a1b35444ebfb8264c1dd341dd0180"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c76dde8e1b042c598eddf892cb25f9621468d2ca5c5d44175fe1e8b999a1ac3"
    sha256 cellar: :any,                 arm64_sequoia: "52428217d720b2c6dacca88f5389696ae10b5fc03ed817ac1dd082c604368b02"
    sha256 cellar: :any,                 arm64_sonoma:  "52428217d720b2c6dacca88f5389696ae10b5fc03ed817ac1dd082c604368b02"
    sha256 cellar: :any,                 sonoma:        "3eaeff460ac2ebd13cb78f1d0cb1080dd96d1748a0d105bbcded5ffc34bb1a8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4006bb3a35033ed7bd2f778d729b323ad57b7776072795127141815cacfa0c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16d8af3472786ddcbdd4eadb923bb592dd610ea7b0308c7a09dd7568927d2682"
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