class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.0.11.tgz"
  sha256 "88a561e5882793c52ec6e6946eb736b418501cacbeceb47120ce25f87db22894"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "f9e61f622226e24d21a14bee214242f2b4ee1ee53a7eaca69fdc4634d33146fa"
    sha256                               arm64_sonoma:  "f9ef28fb73c5f2e1bde79db194e65b3f920f74dff6b50bbf46f9a81866633476"
    sha256                               sonoma:        "71c17bc8a6739aeaadfd9d214ba081a5e147dec6c90a1353563ef21c9572ff77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771772e5f506d42fde72e9c5b6ffcb4393615cd8061a6c39ca98231022bf8d21"
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