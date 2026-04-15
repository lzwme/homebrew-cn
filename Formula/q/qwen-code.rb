class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.14.4.tgz"
  sha256 "57403b345b262ad66bf964de2ad938d53fc0ded3a5342c4393e9bd9cf44d86b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "01bbd19aa69fb4346c1c777fa379fb31ebb4a724330916486d24a573cc383947"
    sha256 cellar: :any,                 arm64_sequoia: "2b713947349ad6c5cf4e064e0fc89b5fc271709ac234219362c796427fe69ffd"
    sha256 cellar: :any,                 arm64_sonoma:  "2b713947349ad6c5cf4e064e0fc89b5fc271709ac234219362c796427fe69ffd"
    sha256 cellar: :any,                 sonoma:        "a60be001f9805538466360f06dc34a31699ac437da4cca64bb95c62353f23035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db8fca84bfd8dab9e316862d8c15912af06e9972fe8256fbe6c5acdd172b6562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9807a01d556ae9ac1427cb3427b4ca7bc05fcc15827c4182c99ca26221d6e17"
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