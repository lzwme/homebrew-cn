class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.1.1.tgz"
  sha256 "885577bfa54ff42e4ea6bd556c62ded0b55f119f1edfca26e8ede0c9f2cc11e2"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "3ab72e1896fc7bd2f54fb7ba786ebc21699700b188b9c7dc41dfc1358de1c4a7"
    sha256                               arm64_sequoia: "d2074486ad05b01bf2d654f149e47e95da2ecac8e007d90423d3338d37d397c4"
    sha256                               arm64_sonoma:  "13ee9bbbd6d6ceabaab605928eed35774102d804a74bca7b1663c2c8802c36c3"
    sha256                               sonoma:        "801cf1742751be81842b62107d621415d40f5d63019b8ba0dcab4f6c275bd888"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dce8ea3b9ee802f504152770b4c4b7ad14536e80494ecb818224e4fff7d83fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae6600b3bb0d76f254f3c84446d05db7fca21f4f1c321a83143878b9847c8909"
  end

  depends_on "node"

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