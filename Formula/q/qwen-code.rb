class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.4.1.tgz"
  sha256 "c80b603052ef8377cc84b7cd5d8e6983e6e434094c553629ee0b4747afcc2ba7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efe98af79c92ed18681cf97f5f0da522ac661132065ccdd82067a8c51a6d34e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efe98af79c92ed18681cf97f5f0da522ac661132065ccdd82067a8c51a6d34e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efe98af79c92ed18681cf97f5f0da522ac661132065ccdd82067a8c51a6d34e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf5c6023f93b671ae3c38103507b8dce9aaea54105ad41cdcb481375e4d4f82f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca6569f9b20ba0c746998af59db67da5cac9d200212d6b7bc4be145f665b046f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87364ca5e2746e17fa839e7cc518fc0d4030f44e4ad528da3a57d21a494591b6"
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