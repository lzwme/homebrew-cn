class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.10.6.tgz"
  sha256 "f5f6acd9eb9a12be4d198db8609f005cf7fde98300c220f80b64aa880dfecfa6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dbe1ef1684e7fd8363bac38f6fa91f0ade1f77e8d46f0f766144dc517c46cdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dbe1ef1684e7fd8363bac38f6fa91f0ade1f77e8d46f0f766144dc517c46cdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dbe1ef1684e7fd8363bac38f6fa91f0ade1f77e8d46f0f766144dc517c46cdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b18c09c399e1cebff795a38f14b93592c579b48cf95a2c6a4c5f41ac67754ea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71c3b73c0d34655557e66b38e31c73a5f835b81f840dd13c222e52231189d11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66bddd8e85c6983a6fdbb1c312210529eaf3e517eeccf66bfabb9b6cf673cd29"
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