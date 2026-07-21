class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.20.0.tgz"
  sha256 "b10b5110b9b04fccc742dda870db7846e10952bc0e7faf8ec981cbff999dcc8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "669788316d02dd52d4d685a63374bc1b99763446987f93c66363394164d23dcd"
    sha256 cellar: :any,                 arm64_sequoia: "669788316d02dd52d4d685a63374bc1b99763446987f93c66363394164d23dcd"
    sha256 cellar: :any,                 arm64_sonoma:  "669788316d02dd52d4d685a63374bc1b99763446987f93c66363394164d23dcd"
    sha256 cellar: :any,                 sonoma:        "b34503c3bafc70ba3131fe2c767845e7ac8939968e50976916305d55d9ad048b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00fecdd68b0e6ec78d497b6e28e3a26dae53d8e8d57e86bcefa33680d5fa24b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a778a4e91d4514df54addab963aaf70f29692248baee45e2693607ac0b872023"
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