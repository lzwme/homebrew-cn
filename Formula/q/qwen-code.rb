class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.17.0.tgz"
  sha256 "6ff28f0d661038a67cf2294db87b92147bc50f536ec550b372ad43f41ae4baa4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "310e5509a313fa786fc81eecd6c92e4959749720736771a0f5c78259ed9e043b"
    sha256 cellar: :any,                 arm64_sequoia: "11a28b65891bbff4645f437843a87bd5d706f4ea210be9e8644e9b7976a25128"
    sha256 cellar: :any,                 arm64_sonoma:  "11a28b65891bbff4645f437843a87bd5d706f4ea210be9e8644e9b7976a25128"
    sha256 cellar: :any,                 sonoma:        "fc6786193c4ef0baaddb10e79708682534103bb1009801cd45e7dd14fde02297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e4446c7cfa79b76afedf921c39eec4e88d5a79fea836f4cfeca3a2bdb444c8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b931380cd8d8df28f2d054897f0f29903acbe869b4add3315210346fa17b8a4b"
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