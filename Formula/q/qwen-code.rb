class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.9.0.tgz"
  sha256 "336320da14d21992e8b40ce9950ad35658643009ea3d5fb18664aa541563e6d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2551af73ef892c73db928769bd3d2bbcab1bcb1f95e14b9e060df4f386e678a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2551af73ef892c73db928769bd3d2bbcab1bcb1f95e14b9e060df4f386e678a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2551af73ef892c73db928769bd3d2bbcab1bcb1f95e14b9e060df4f386e678a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4db6e14ed8b5f84003c27f7c0b5475561273b4adc1cfa3ce3d480ef108ad611"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5053f3bc3f5ffd8c3b24963a0444f9de71d6e1aa759f95a5bacd3d287d55da57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebdfbbf23626db961feba55c1f08bf31be1b00642b7e03afec6c0a74824dbd23"
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