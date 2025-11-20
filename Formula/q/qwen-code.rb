class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.2.2.tgz"
  sha256 "a8adb6ee39c1031057230761af2f8767bd2e2d366834931afba925967797bbe1"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "ff39872d51ac71873c470d07d5379f9845f2fe4d97a44b6e3c467d81077c2ab7"
    sha256                               arm64_sequoia: "09f729775b06ebca80f7b645eb53d24e3a84a107f4427b7bf55fed1f42b1403a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "575c2f1e00a04ea5b80a8313f1241254887a6fbaf794224259791c30a94032e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1de3da32e5d9b531416363970da317a797b38d94c76fb1657dc225c8be74dbcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c882065b2ad184b0394ca639f0e727af4227b42f1e9001f898f8e73f60c2c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "779726c1d760fc1d476808012540fbd05711b61ae6475dbb86759637f5b62b85"
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