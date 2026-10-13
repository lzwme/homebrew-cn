class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.25.1.tgz"
  sha256 "674b31eada2d2ffce10c5085eafef15a0a5ac556e597729d28c56d02b5c6302f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9b76d04552df1ba885bffc5d56e0317568b04d1e61a1672ad546fbb3250633ac"
    sha256 cellar: :any, arm64_tahoe:       "9b76d04552df1ba885bffc5d56e0317568b04d1e61a1672ad546fbb3250633ac"
    sha256 cellar: :any, arm64_sequoia:     "9b76d04552df1ba885bffc5d56e0317568b04d1e61a1672ad546fbb3250633ac"
    sha256 cellar: :any, arm64_linux:       "39e23c4787f34cef5e74579925a8a679aca95c61e60f1d4d13a0ba40c8dd75a6"
    sha256 cellar: :any, x86_64_linux:      "79a19c0dc515976576de6a912cacaa52378bc1b64b9cad754ab7a38cd8889b44"
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

    qwen_code.glob("vendor/landlock-run/*-linux").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{arch}-#{os}"
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