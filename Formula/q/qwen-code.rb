class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.10.0.tgz"
  sha256 "1e90693e696984ea227f033cd4ced0fe9210d58ddb7b45a281e15905a9265670"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed536cf73b7cdbe2f5a84ae93c008d3e54236d4edb16c6bb9fcc5cbf0857f13f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed536cf73b7cdbe2f5a84ae93c008d3e54236d4edb16c6bb9fcc5cbf0857f13f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed536cf73b7cdbe2f5a84ae93c008d3e54236d4edb16c6bb9fcc5cbf0857f13f"
    sha256 cellar: :any_skip_relocation, sonoma:        "778b2461dcf25752c05c253959e10087863c8a89a6b9bd59a20f33b232712342"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df617146531982fed003443adcabf8554250de1710b6c79456083522e49bdf4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c0740473dfe64ce31e6321482a81630d71b59ac6789c96c2608443702f0c86"
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