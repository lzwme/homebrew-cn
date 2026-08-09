class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.7.tgz"
  sha256 "9a5c6efa1e8632f8e3243455f553d8749360d97f958750b6666b622ce2cc1d25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3bbc3e0bedd5d40641572f8efd83b1b08eb2a756919d27b201ebbd9c7c1698e3"
    sha256 cellar: :any, arm64_sequoia: "3bbc3e0bedd5d40641572f8efd83b1b08eb2a756919d27b201ebbd9c7c1698e3"
    sha256 cellar: :any, arm64_sonoma:  "3bbc3e0bedd5d40641572f8efd83b1b08eb2a756919d27b201ebbd9c7c1698e3"
    sha256 cellar: :any, sonoma:        "8066135714f0ea9522ce2e2da7975a9fa8c1d54934129ec360692d2e933fd00f"
    sha256 cellar: :any, arm64_linux:   "9371b35291dfc5a0ea829f8a4405a6e911bd04f5f8510ea43af047339cc1d5b5"
    sha256 cellar: :any, x86_64_linux:  "b49ec9479459ca4c1c13afd96a06b7129ee44aa0c5e45da6aedf96d1d5ff8b2c"
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