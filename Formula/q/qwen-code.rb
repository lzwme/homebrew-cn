class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.24.5.tgz"
  sha256 "539b8deb2cbc2108df3d1d763f420566acfc83d2d3afa202f7da585f1c2e4f2d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "658117099d627c867bc55411cc4480ffedc18d455473cdb23465da44628d3496"
    sha256 cellar: :any, arm64_tahoe:       "658117099d627c867bc55411cc4480ffedc18d455473cdb23465da44628d3496"
    sha256 cellar: :any, arm64_sequoia:     "658117099d627c867bc55411cc4480ffedc18d455473cdb23465da44628d3496"
    sha256 cellar: :any, arm64_linux:       "ab9cbfa53572a061923d70ab437757a9b9676023f407f46d43cd141d1c3d7c57"
    sha256 cellar: :any, x86_64_linux:      "a55c811f38d48af7cd6557fab3ce72c073bab423a0ca9cc1981e74f054622689"
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