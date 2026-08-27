class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.22.1.tgz"
  sha256 "1108f84ad96f9582c7513f4d83fde2e015b54d0b32239943b1c4ce4044a0f998"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "308ea9b6418d1bdc0326599a3d2f429560c2638c91e896708d1efe54351c3fe1"
    sha256 cellar: :any, arm64_sequoia: "308ea9b6418d1bdc0326599a3d2f429560c2638c91e896708d1efe54351c3fe1"
    sha256 cellar: :any, arm64_sonoma:  "308ea9b6418d1bdc0326599a3d2f429560c2638c91e896708d1efe54351c3fe1"
    sha256 cellar: :any, sonoma:        "66438f4c55ab43920f8a1a9f8fa82136297e991000b09db1f341fbaa61069b83"
    sha256 cellar: :any, arm64_linux:   "97cdba7b5f6c951effd557eb49838120e88519771c57b90f7c3f11e7e15b0734"
    sha256 cellar: :any, x86_64_linux:  "fe0ed62e9badfe406400cc9025b87773cb727d98add8e3c9862db80a3e0bdbd2"
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