class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.12.2.tgz"
  sha256 "a218db25d0be08cee3594b942b9d3ae3c53612ca8f886a7e9702acd25423dca8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da4cf9a26d488ca381427f7cfadc9da67c9336b99402fc95e2a335eea053f985"
    sha256 cellar: :any,                 arm64_sequoia: "7737af3f7fc1cb200d4124f5136a57f7a91fc631f8e200d26678b4b8626cc8df"
    sha256 cellar: :any,                 arm64_sonoma:  "7737af3f7fc1cb200d4124f5136a57f7a91fc631f8e200d26678b4b8626cc8df"
    sha256 cellar: :any,                 sonoma:        "987325003ac9100f8c52cfaf66553f7589d066f2dc52bfa7a1bd38f652a3d804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77f9db4d438e00f9bcecfecbc8861b3ad72b4578e8cddbfa4b035d9db2beda8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d2968552f8e707a799aa9b90fbed4b4378b0684970183fed7c07e8fd99f8a4"
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