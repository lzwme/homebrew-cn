class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.12.3.tgz"
  sha256 "f7671a05b2dea9922f37a206dee3d394c80ced5451bfb3e0d823af0330042beb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77289ce06dd27c0268c4f8e5cb83f6f2d4efdcb0a2e88b740679ffa47945add8"
    sha256 cellar: :any,                 arm64_sequoia: "fdd5a2ed415cf1a1efeb32b0c5b5ba39bf8e50b6ba7f1fc6ec3b8dfd7aa78e1c"
    sha256 cellar: :any,                 arm64_sonoma:  "fdd5a2ed415cf1a1efeb32b0c5b5ba39bf8e50b6ba7f1fc6ec3b8dfd7aa78e1c"
    sha256 cellar: :any,                 sonoma:        "69ec9b19c96e95070b0d00ff0de095f51e97002a1bd51eb10f9151927680fbbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "219d9c0daf078707fb2f367e84b9526d1cecdcd4ea630d108341bf8c1fbed2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "370e10252dd16e3466f5addcdf0afeb23047e38c7776e06f8e50d0a2add41e30"
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