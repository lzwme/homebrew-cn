class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.19.10.tgz"
  sha256 "cd35adbc46f39ae7e55285c2c8b2ae5ef0ec70dd3091316c2597ce29d0e1f7b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24e7ecc0c071bba6bb4ba7631594247e4c428f8097675b5c5f2c4cbb554bd9c5"
    sha256 cellar: :any,                 arm64_sequoia: "24e7ecc0c071bba6bb4ba7631594247e4c428f8097675b5c5f2c4cbb554bd9c5"
    sha256 cellar: :any,                 arm64_sonoma:  "24e7ecc0c071bba6bb4ba7631594247e4c428f8097675b5c5f2c4cbb554bd9c5"
    sha256 cellar: :any,                 sonoma:        "97066c961304b120ba8c5cd319e175917ccda81941b746a7c7bb18b4cf76e568"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe56067cea5088003fd9728216ad511433a7bf360d809b35797a9b1517eddf67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bf010c085d2c4d382be47388c40563fd35514b842c8d0b0414083e3352346b9"
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