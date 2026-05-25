class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.16.1.tgz"
  sha256 "16144ce3494bf2b453414db084ea5c7c9ffe8e874e49cd9ce48771b59fa4869e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7cb34a65640a1d94e468a7cbf1983c7a2fccfb294e31911c4724cbde3c60ca47"
    sha256 cellar: :any,                 arm64_sequoia: "1be7990b79b1eef874cdc8af4ddef112318f925e83d40a8cf9a2ab78dbc21ea2"
    sha256 cellar: :any,                 arm64_sonoma:  "1be7990b79b1eef874cdc8af4ddef112318f925e83d40a8cf9a2ab78dbc21ea2"
    sha256 cellar: :any,                 sonoma:        "160d1341969d2eaaa7c0bca75f75d44de04cb190ba56c1b54603ed258ef1cda6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4430778d52398157ae85bfc27cd47e0dd308380ccc3e4a10e1f85d375551f399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8252c5dd71cc9135b34162b264bc1d8862d24d986a4fab89adbfa9586e0ae2d"
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