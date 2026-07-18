class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.11.tgz"
  sha256 "29a6d8d1150a734c10c737f4d67c7af806493c6408d3cf44d62e47d64fecc3de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e437908df8c05d8080603115460b79872cb7e489a132ddaa3a243ac71c428ce7"
    sha256 cellar: :any,                 arm64_sequoia: "e437908df8c05d8080603115460b79872cb7e489a132ddaa3a243ac71c428ce7"
    sha256 cellar: :any,                 arm64_sonoma:  "e437908df8c05d8080603115460b79872cb7e489a132ddaa3a243ac71c428ce7"
    sha256 cellar: :any,                 sonoma:        "ab240d6259cfe4a622c021545bafb9037f9df1c90e02ff3a3765a9b5487c103f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7bd3cae8b863c89f81af622a4fe822d09379b5df342773f25872ad3fe016c40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f359be5062b82f560df1c8daf88662b7389a58f858d05f35c21cfcdd7052807f"
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