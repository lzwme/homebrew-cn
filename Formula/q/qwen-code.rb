class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.24.0.tgz"
  sha256 "8302881d432510403a9cf34d31d115d6c7d56142b89e2b5184284f9dbdbd8a24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1697f03796861c845f63f981cce7552114ddd608bde840bfac287ea97405d50c"
    sha256 cellar: :any, arm64_tahoe:       "1697f03796861c845f63f981cce7552114ddd608bde840bfac287ea97405d50c"
    sha256 cellar: :any, arm64_sequoia:     "1697f03796861c845f63f981cce7552114ddd608bde840bfac287ea97405d50c"
    sha256 cellar: :any, arm64_linux:       "e9b1246c4374bc2093926e49fd5be40aef08010ee0a1e5d8a4690b3dd92edb2c"
    sha256 cellar: :any, x86_64_linux:      "788cfd35b919ad2775487ac652d1a475e738e690087a0ec8d518be39194a4a16"
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