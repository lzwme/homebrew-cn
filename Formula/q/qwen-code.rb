class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.3.tgz"
  sha256 "62814f7a7e70f6b52187c2003203f4727fdfe16b9c0fbdc6a9349c6ef2175c66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "90125f7543c89599b08ec3fad174a47ad5befc9574003717a2a09d541b509519"
    sha256 cellar: :any, arm64_sequoia: "90125f7543c89599b08ec3fad174a47ad5befc9574003717a2a09d541b509519"
    sha256 cellar: :any, arm64_sonoma:  "90125f7543c89599b08ec3fad174a47ad5befc9574003717a2a09d541b509519"
    sha256 cellar: :any, sonoma:        "2e0411ddba6f1b76c4734a3d56caf5888180545dc9028fd337a72421b8ff1f28"
    sha256 cellar: :any, arm64_linux:   "f76c153c8b74bdde73e1c69000343f9dae2d222e05a6a4ac2864fddbaaa455cc"
    sha256 cellar: :any, x86_64_linux:  "f527f52dc3175cfac5c1c8accecd64b07586379248cbcef2e1ef71e4036a7214"
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