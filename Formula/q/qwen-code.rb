class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.21.4.tgz"
  sha256 "243df6c3a3693cec83d2b1005f33c5ff0d0e5b8bdf3fa627175b8c1c9925b9b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "75a8a1de5d673c8338e7718b4d907cdf7aae63ecb46b0ea95cf9d455853052f9"
    sha256 cellar: :any, arm64_sequoia: "75a8a1de5d673c8338e7718b4d907cdf7aae63ecb46b0ea95cf9d455853052f9"
    sha256 cellar: :any, arm64_sonoma:  "75a8a1de5d673c8338e7718b4d907cdf7aae63ecb46b0ea95cf9d455853052f9"
    sha256 cellar: :any, sonoma:        "4a14bf7b9425b009e3a38efcf2f43020acf8e4b460bee11b7f9c1bb0be2fbbbc"
    sha256 cellar: :any, arm64_linux:   "b2e79a778d0b0af61c7e6a62a53c2f90aa1d7d287d68747dc760dddddfbc4431"
    sha256 cellar: :any, x86_64_linux:  "a3546f788cbc40042ebe363590f0606c98100f877840f74aea65ce077396b8c3"
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