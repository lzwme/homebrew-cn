class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.6.2.tgz"
  sha256 "8cba41bdb41f851a5fdee8b3e38e37306e45b1d511c2d675664231aa1893620b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f328f4ba9af681dbf5995b2ea2ccd09c7c6bcd3194d316b9f8141b3628ff605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f328f4ba9af681dbf5995b2ea2ccd09c7c6bcd3194d316b9f8141b3628ff605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f328f4ba9af681dbf5995b2ea2ccd09c7c6bcd3194d316b9f8141b3628ff605"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a3d4ebbd9bef7946b2c84dccc0da79b08b8d93b121806126e8c250b61f71ba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87fa42733b9a463eb9f7b9c71386c47e7ea022ff0ac6c7433619e64724093e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3e8346e7360c064c25744b89c5a4d790aa1311351ebe84b6f4396d9cd182a6e"
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