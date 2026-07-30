class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.1.tgz"
  sha256 "75c036dcd78384c9bd19a9e07afd802226bb83531ef34a63f8fa14a3629ae2fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "164814a0b6db9e5812d161f776a8742742a47f473f9f3aeea19ccef6ee06204e"
    sha256 cellar: :any, arm64_sequoia: "164814a0b6db9e5812d161f776a8742742a47f473f9f3aeea19ccef6ee06204e"
    sha256 cellar: :any, arm64_sonoma:  "164814a0b6db9e5812d161f776a8742742a47f473f9f3aeea19ccef6ee06204e"
    sha256 cellar: :any, sonoma:        "fece0dffede5c7aae43123ff5d55996de7ed96d4e955d5ed5b6e97bb9d83541c"
    sha256 cellar: :any, arm64_linux:   "b77c81b2e42ab7897f09f603ff97a81f70ee5d67a4b20321be6ac458bd763260"
    sha256 cellar: :any, x86_64_linux:  "72910adeb2e5827db0013bb2a4c3c494c1b738f31816d83191413640423c63bf"
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

    qwen_code.glob("node_modules/@qwen-code/audio-capture/prebuilds/*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end