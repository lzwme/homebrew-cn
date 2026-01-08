class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.6.1.tgz"
  sha256 "c28cca078d05fd6e1c82c49f6d9ad57c870eeaac5c481be16d32e9db63b62879"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "908b3f1b45ddb2b4aeeede5eeed5f61cb5357299ebe1be3e1996e7bc52636dbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "908b3f1b45ddb2b4aeeede5eeed5f61cb5357299ebe1be3e1996e7bc52636dbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "908b3f1b45ddb2b4aeeede5eeed5f61cb5357299ebe1be3e1996e7bc52636dbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d63f75e4f4b8d72dca23bbd58add1e2fce74d7606f855cc79fec57e069673cde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2049227a8f5c7ec69f0176be94afac983417c0d2fe1a20c79c1da99db69527ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50b17086a86df4be269e8f1362cd2aed9398ec0b97e9c0d23813d432290afb88"
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