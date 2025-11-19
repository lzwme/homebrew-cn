class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.2.1.tgz"
  sha256 "1ad1015a788198236ac04ea64784acf15191c195760a840817a140e2337380cd"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "60b15d952e516f832aba3284261dfc74fb54a89e0a34ea4eb1466e7419e82dc3"
    sha256                               arm64_sequoia: "3883e09999a486d976cc0ce2f35f4f83982302702b5df40a250c8d49757d9259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72276d2e6e6001d68cf69faa88c2a47b4a18dfea5c7722257bfb654167ff3517"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ea5dfc3c9d1b2e5bdbba948e07eab1a142d5cb2fa018b209394ba78b43df213"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f62fadb434fc8477f4d114b37afe01b4ed24e8bd39da41b469fc96d12eb6ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4510ab5d2b1d0f808aece5f3fc61639e2996b7b89e55cf79f3b379c1c105ecf1"
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