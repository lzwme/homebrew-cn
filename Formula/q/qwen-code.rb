class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.5.1.tgz"
  sha256 "27ef03aafbc82081af63d400a4766044ba89dced4548370559527d2ed89b57f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15f65819b88921f5cdd5169d5b74fdb7a7087908a06534162d3ecbc6bf9aaffe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f65819b88921f5cdd5169d5b74fdb7a7087908a06534162d3ecbc6bf9aaffe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15f65819b88921f5cdd5169d5b74fdb7a7087908a06534162d3ecbc6bf9aaffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "332255838450bf25059a8c0be713fa661535e6ebb7cb50a55f49535bb55f0ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e1b4e917a1fb27d3b7eff2fb1b99bee89a071edd30714493e83ccf3f093d53d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc6f57173147b29c68a09479d4096d4bbb570e6403f30466a93ee9dfc8024c1c"
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