class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.14.1.tgz"
  sha256 "2fd85a0d67d24c67d12bc7e87bb975bf0f8961a853b8260b47b058b3b78a0040"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "accb4452d1a8566eeca3d25df52dddf93a366ba642d0925002fec21ca9f4f08f"
    sha256 cellar: :any,                 arm64_sequoia: "ec6c7dda7ce05f5e430e0d8f386741def903da6f5b636f83a1e429b27a48cc03"
    sha256 cellar: :any,                 arm64_sonoma:  "ec6c7dda7ce05f5e430e0d8f386741def903da6f5b636f83a1e429b27a48cc03"
    sha256 cellar: :any,                 sonoma:        "1e1be79c8045e282a11c63a6402416ac2ab14db4aa33189080b4136d6008c247"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3544f60fd89ec9142c16406510d9209c9ec5404f47578fce3ae935a8a99beda2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7475d9e5406eafdce1f77f311706b9847168e7c1d6cde4946ccb97e6d5d0568a"
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