class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.4.tgz"
  sha256 "18fb2f321d8e2acd321ccab3b035c5789bf35e631cacde74ecda13dfaec70909"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "496aa2c52027b4faea724817bef122f6e302e38b3a7dd39a3dc32b6cde8db4fc"
    sha256 cellar: :any,                 arm64_sequoia: "2f9cf8e7aee3dfb6ee3ab0f4c104928900aeeb6a9065583ef57a9a5297306cda"
    sha256 cellar: :any,                 arm64_sonoma:  "2f9cf8e7aee3dfb6ee3ab0f4c104928900aeeb6a9065583ef57a9a5297306cda"
    sha256 cellar: :any,                 sonoma:        "9111e27f3862aea8953cd1f14a9a57450f5b7c83a3982c3328af0b3a0631aef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e79dd33318c43792ee6ce448f0bd80661f36ba6d85dd2c3b4eb2c37cc1bc3d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da1f5e5180d20f9f8a7e2c8b38278564f178c20901ef6d87985d0b4e55d5edf5"
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