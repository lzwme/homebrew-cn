class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.9.1.tgz"
  sha256 "74afb3ab7d50f5a6a2bc0d9172846eb87e2112addf034be18bdc03ed05fa16a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1a5819889631b0f8a035b7671b50a43ade9f16de55b5460ecd909f3549ea92b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1a5819889631b0f8a035b7671b50a43ade9f16de55b5460ecd909f3549ea92b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1a5819889631b0f8a035b7671b50a43ade9f16de55b5460ecd909f3549ea92b"
    sha256 cellar: :any_skip_relocation, sonoma:        "226ae251a0db5a1063501e265a3c0603405275bd7102f5e4ca0920a6399289b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95aebdc5e1a143c039c8092dbc3b34c1952649228cb4ed09707ca050a1e13e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53324e3ec67828a10aadd6367e73e843ce26e14f3477f00a5d995d1fdc87a7a0"
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