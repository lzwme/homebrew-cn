class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.8.tgz"
  sha256 "f6a33be24cb0a3390b20ad8c677fa8eb6607918b1a735f1a584a09780fdae7b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8b1d6dfb6c3785fe3e696d431302730b5743eba6d82457050d3d4e4f084cba7"
    sha256 cellar: :any,                 arm64_sequoia: "042bb32d65e6957121aeb4357e7f269b7bef2e0c6f262f5c7730f45d0efc10fe"
    sha256 cellar: :any,                 arm64_sonoma:  "042bb32d65e6957121aeb4357e7f269b7bef2e0c6f262f5c7730f45d0efc10fe"
    sha256 cellar: :any,                 sonoma:        "3b1a896ff541317ccada59ab0a944c3419b0b9c0a41ba7727f12e4c5e7e61386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4461fd9ef1cbb9f6bb580711f65e106b6c0fc445300c8e0809ec95c4b14dd5f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "575a4ea78e52c004612be42775251086cd337dc200949f0a3530426e92988b44"
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