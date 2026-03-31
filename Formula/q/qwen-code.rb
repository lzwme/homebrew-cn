class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.13.2.tgz"
  sha256 "9750d44703228cc6fa1db3fbb27bbc0e6cc53aaf98cf61c640c4086bac9151d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7feb25966d95fa419786abf731e3f77475318efe6a47a9bc11ec565abdde9ccf"
    sha256 cellar: :any,                 arm64_sequoia: "2dd63c4c35fa5d53c3ae43e15863e8e4cef2be415af5b3a7c20802fc69664124"
    sha256 cellar: :any,                 arm64_sonoma:  "2dd63c4c35fa5d53c3ae43e15863e8e4cef2be415af5b3a7c20802fc69664124"
    sha256 cellar: :any,                 sonoma:        "79bf78a54c87e94cc931510c364036262f310d41eb599873350f277bc1cd5a0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66802ace3bfa14433f3bd395e28748b3b5989daa8c74bd847f1bb0decc13c492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29b5d3b8e934e1ad21eb3bfb56486c269714c59e64704db1aec50225abe1f4bf"
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