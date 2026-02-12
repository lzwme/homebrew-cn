class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.10.1.tgz"
  sha256 "07d7d4c0a115fb53c356c63313e66a5d8844ac4f01aca6166a01ef5efabc65f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f4f320bc1419f0faba3316585813896a0e9db84323fd37007d98dec9ab8a260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f4f320bc1419f0faba3316585813896a0e9db84323fd37007d98dec9ab8a260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f4f320bc1419f0faba3316585813896a0e9db84323fd37007d98dec9ab8a260"
    sha256 cellar: :any_skip_relocation, sonoma:        "718da2b5c655b76ebc97ddf02cfa4596887f8e09ea102584af29a91ed9295696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2316465781ccd2e94be53e15857a5cc9f6daac8165b2a393e5e100f2e30a42c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b04df5031023b6e8db486ba00c23b1a2e7b5def34aa2ce9571c611118448e626"
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