class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.6.0.tgz"
  sha256 "6a14d1619390a1a6587073780910a8c9819babffdda1699fd8ca4ac6d63e2b02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4b6e242e4ee25d543be36fac312e0263441c99a2bf612039a5e7cfce839ec24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b6e242e4ee25d543be36fac312e0263441c99a2bf612039a5e7cfce839ec24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4b6e242e4ee25d543be36fac312e0263441c99a2bf612039a5e7cfce839ec24"
    sha256 cellar: :any_skip_relocation, sonoma:        "5495d6d1e47d2c4b68efa68f6169f17c3f91471610262a870b3c60265cb9884d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cde8ccf4f4f2731ae85f7407b9513f3509429268409bdea92cc5b553ce3478f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "124f7ee5d41c9c2fc00859fa5d7bf33f19b8c22bfc5a116390ebc8ef49d32668"
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