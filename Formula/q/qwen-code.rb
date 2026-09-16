class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.23.4.tgz"
  sha256 "d590c8e27fdd112cac4b0ce5ee98febdb91cf660c01db86ae431870f8ee41a9d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "de984bee0d2858510b3f81cf27188492d903c72a38792f179a061245daafa4ce"
    sha256 cellar: :any, arm64_tahoe:       "de984bee0d2858510b3f81cf27188492d903c72a38792f179a061245daafa4ce"
    sha256 cellar: :any, arm64_sequoia:     "de984bee0d2858510b3f81cf27188492d903c72a38792f179a061245daafa4ce"
    sha256 cellar: :any, arm64_linux:       "9d60e284c3b768bfef1c93cc4755547f10ee27195fd746eb19a5c6a40dfa2c28"
    sha256 cellar: :any, x86_64_linux:      "23986831f0ef57da66b0fa236cafe6e852d2293cb209d051f9382837960380a5"
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