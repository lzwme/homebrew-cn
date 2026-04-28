class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.15.3.tgz"
  sha256 "f8a35f3e779a84a1b82bffff94bd529d0de2b7b0acfa8598659c4d4607e15109"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f70ffdd87525649fd1fb0bb8784170cd771f08ddb852fc3344b060e55a230bc2"
    sha256 cellar: :any,                 arm64_sequoia: "5016a23e37460ab52d0ba20a307e138dc799d4fc10359be0f297bb829baebdae"
    sha256 cellar: :any,                 arm64_sonoma:  "5016a23e37460ab52d0ba20a307e138dc799d4fc10359be0f297bb829baebdae"
    sha256 cellar: :any,                 sonoma:        "520278401a0b9b1202060236a8c479af603eec2086f301c429789a43bad4d8aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab02aee83a39e77f2861ea5c82e77c27272e4d8bea2b295fe201c5cb40e1db53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5351fe0bd417ca9b24e2ef1958b5b981ae572468c0853ec067b2c1a026a12cd8"
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