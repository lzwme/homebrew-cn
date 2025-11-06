class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.1.4.tgz"
  sha256 "2c2c98d889ec4af75f5476fa17dc1f269bc3ba31abdd8d07db4b31d7378e0985"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "5fa4c02cbe225c867ec91d8313356a26fd66eccc28b349b5a124deddde555398"
    sha256                               arm64_sequoia: "f00d3684e63d77df3f93cab685380fcf1adb88d57e2d7f60406c68cc9c770584"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbdfa324133644391fe9ec38a09abba3dd964e06e40f39f97bec2542d6b77efa"
    sha256 cellar: :any_skip_relocation, sonoma:        "6140746b68dfa6b868536b43b0050c8409f3cadc01384952e777990566b3815f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bec937b0b7c4b060852ef0108849731ee5a834aaa9fc6a913447cfbd2977a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ecf9918440bf021de6ac558844665f2cb6e37a41f56de05888aa589550cbd6a"
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