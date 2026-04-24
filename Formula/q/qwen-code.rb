class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.0.tgz"
  sha256 "b17d9ba7b49fc5f633d64ef634fb7f0395957c1c67cc99fd1a9ce0549912134b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff1c1b0679d07351231b8e70beef5eff9aab42e52868dce8b7b785be3e8790ea"
    sha256 cellar: :any,                 arm64_sequoia: "7de31191ee35a94a785be700d9c5a9cb26f542910ccadb91394e590009fa9f3c"
    sha256 cellar: :any,                 arm64_sonoma:  "7de31191ee35a94a785be700d9c5a9cb26f542910ccadb91394e590009fa9f3c"
    sha256 cellar: :any,                 sonoma:        "620a1d5645ab8480c02cef4bbf91b3b7c4432c7c52976e4d25b75eac18b532d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bced25a97864ca3ee737c2a323c5e9f32d1869fad66432f464f040e3ee81502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26651207b5972ab7be1aa0422b16f1c3e9fb6aeb01fc615b392f3e89f82bf36c"
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