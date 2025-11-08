class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.2.0.tgz"
  sha256 "e56af14622098347192b06a8bfedf04f0b6072dfcb9768934af866b56ae120d0"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "2bf0bdfa18c8ae012ea87530922bb1ef11ba54c34fd281152d44da80f645bb43"
    sha256                               arm64_sequoia: "3e6b831206e533fa089753b71cc66c4febeeb4c341d9f93a2a6b52db4ee3c3e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c904759c2c5f9b7b3392899f3adb8dfbaab0a7f574f5f17e4f2846e526c928ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "cac1abe67ac3671fe7279c1df3f32bf15b082d23ee36d80d2f18e7b8c3f019a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e4a8dee593e495207bbbeeaede26fedb61192477c2d6fc6d7d4d5928bad7c5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d07ca974a24df0267384714d24a19221851e8c4441c257b8df3002ad883b1c8"
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