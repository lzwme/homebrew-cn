class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.10.tgz"
  sha256 "0e76c961116aa85f7e04b2fa7add09193cd8e68343e0d73c2f7704ed2870c366"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ba21e27008ff1aaa0a304ba911b20454b8d25f6ce4d7f5cf48372743e6c31b4"
    sha256 cellar: :any,                 arm64_sequoia: "f876ff57ec376db8e53cfcb69c8f5113cbb363be3f9f348d5e7f8a28a77a122b"
    sha256 cellar: :any,                 arm64_sonoma:  "f876ff57ec376db8e53cfcb69c8f5113cbb363be3f9f348d5e7f8a28a77a122b"
    sha256 cellar: :any,                 sonoma:        "d891463e9ae1987fa8ea461b4067e380553e00a5405d09228c9e97f96bd60563"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eaff68c82e85a56e4a3df096773d5378333ff59a20bf6c3d892d3b640577aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fd53f8be64a3bbc844bb340c7b07b19b8445c2baceda8ed3bdfea5ee4a48afa"
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