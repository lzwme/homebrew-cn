class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.11.1.tgz"
  sha256 "6d38b8344e9b78a101351962ed7c81d144b67d820172c16da4756e8bed456879"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4de6de8d604a056b2dd7e508031e2773d110c86db046496b79111427efa00254"
    sha256 cellar: :any,                 arm64_sequoia: "15f91ca1b46f5c4aec177d277c0b570e1dacf9c865c213e3591daf6ef724cbe9"
    sha256 cellar: :any,                 arm64_sonoma:  "15f91ca1b46f5c4aec177d277c0b570e1dacf9c865c213e3591daf6ef724cbe9"
    sha256 cellar: :any,                 sonoma:        "3439a90ba29e4bab44232a18c92bb9a7c1fa51c072ace39d5b6fa697ed079b98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53137681d03015e802f69e0e1975b68502c61a1a59bc0fa0a268986c7c15d694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88a1d026dc1dd7c1ad86e9628cddb7b73495157002bc89b69b1601681e51be3f"
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