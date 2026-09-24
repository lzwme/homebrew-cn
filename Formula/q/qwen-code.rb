class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.24.4.tgz"
  sha256 "7840ff5c70010be9bd7c903d1ec0893893f5429fde5b4e8a189f61450269d8f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a4017646efa1902b40be6485f13a77ba0900c3a4e7b33eb037abd15bd3adf16e"
    sha256 cellar: :any, arm64_tahoe:       "a4017646efa1902b40be6485f13a77ba0900c3a4e7b33eb037abd15bd3adf16e"
    sha256 cellar: :any, arm64_sequoia:     "a4017646efa1902b40be6485f13a77ba0900c3a4e7b33eb037abd15bd3adf16e"
    sha256 cellar: :any, arm64_linux:       "86ad8a830d86790b5c63fa4701e8358b0ff1cc809c823dc0759fc70e7126772a"
    sha256 cellar: :any, x86_64_linux:      "beb22889a4146bb3e9e55965c5edd2bada1db518370845eebf836470822fc324"
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