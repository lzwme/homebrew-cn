class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.5.0.tgz"
  sha256 "5ecf7c508ff5a8a36f9d1fb257aaebe01b6e91d7a45fd217dd7172a360905981"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eed168189af17f7f28b3b5b2fe39d0ef6205ed93d0da76d33a9deeba127fe9b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eed168189af17f7f28b3b5b2fe39d0ef6205ed93d0da76d33a9deeba127fe9b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eed168189af17f7f28b3b5b2fe39d0ef6205ed93d0da76d33a9deeba127fe9b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d337cf7e3b0f76e894a4a7646e0d30c8aac3bc489710da68309b1393ee86d9ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5791155804eefe7d190c912d6343c87e076190d2395de70b4064d9d5518f5f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb4e0a5866945802a00ecf5c6f202c35c6f11f55b3faf8a93e8e1f78ded5d92f"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    rm_r(libexec/"lib/node_modules/@qwen-code/qwen-code/vendor/ripgrep")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end