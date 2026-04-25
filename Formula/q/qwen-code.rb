class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.1.tgz"
  sha256 "2db2be719a604d27b5bb573f1aef85fd9b8b2dfccd9f9e13a6e8c3d052d0cbe7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2cb2c74f46c049aefebc6dc64c2883fb3a3e03e9f6292f5930d1fc41c22b4b8"
    sha256 cellar: :any,                 arm64_sequoia: "0c7fac0f6d4fa5067f0fcff5d4c52425d563d7f12682a0e7a2aef1f0eb0c0eb2"
    sha256 cellar: :any,                 arm64_sonoma:  "0c7fac0f6d4fa5067f0fcff5d4c52425d563d7f12682a0e7a2aef1f0eb0c0eb2"
    sha256 cellar: :any,                 sonoma:        "414a45be9d27661de7874e9323e8b0ed1ca7e7b794fff67064d0d685495ac82a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9283e28cb8f318f4a723acd48c9228681f6f791a0879a0a879d67f90dcf81fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1f977dbf76b19d3ae1345154c58e3c6d9fa5d8381e7a1c92f82af7eec0e84c4"
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