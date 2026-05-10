class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.9.tgz"
  sha256 "28ddbfc9effa07c34eeab41025a3dfd1f985a859368e2dfc674140256444bb70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "43c17c5d957001d9de818150ae08005150b3409f18b90eecafa025ec0fcb46cb"
    sha256 cellar: :any,                 arm64_sequoia: "aefda44723646721f47af242e966d74b5f810252e6bc44631d2a61d04a56866b"
    sha256 cellar: :any,                 arm64_sonoma:  "aefda44723646721f47af242e966d74b5f810252e6bc44631d2a61d04a56866b"
    sha256 cellar: :any,                 sonoma:        "c90ca4d266b04d874ae99389ad2b1997068be15dbf7d5437c8d32f6adcab9ef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b1dc64bd8a30fa39566e827f30924e9b256cbc56f4dd2374336cc5bea9ff23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ab691aad47936ca6a4feeec15641aff80f0d4b3ed1a7c68a324096dffca81e0"
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