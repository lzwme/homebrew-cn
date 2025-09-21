class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.12.tgz"
  sha256 "439fdd35bc2f7e0cc2cc7a20f927a8184b98319e57049128f3fe4b8629c6b792"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "4c827adbfc083d21913ceb10a9b7f9d44237b23f13735ae45154314351e13c90"
    sha256                               arm64_sequoia: "49fa8f07358e078c46cf37236a403d5b1b757a2e7af4b89bec2bd2abea7365b4"
    sha256                               arm64_sonoma:  "abccf359d85fb4498c00de345a527e3a5410bb3aeada866b24a0d0fc852777b0"
    sha256                               sonoma:        "d9b95a41053c07890ee1b04779d4e8f5e28447194ce97be3ad873336f06fa552"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f004bc309f3d038eb5495a2c56d2315be50a4bd037c420743ba5f82a09a3170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a6f5aedab8c0c4c5528911185b21d1f08b92b607af12ced0c0acc938434107"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end