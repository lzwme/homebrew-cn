class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.31.0.tgz"
  sha256 "c827dd7a138d40aef417d4e794d6aacccf3c6df3867ee83b39d36959df589fb0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "610e2ec4d3ce3f900c5375a217d06c4b0697a0210972812501ea2a161d8e7afb"
    sha256 cellar: :any,                 arm64_sequoia: "610e2ec4d3ce3f900c5375a217d06c4b0697a0210972812501ea2a161d8e7afb"
    sha256 cellar: :any,                 arm64_sonoma:  "610e2ec4d3ce3f900c5375a217d06c4b0697a0210972812501ea2a161d8e7afb"
    sha256 cellar: :any,                 sonoma:        "c045810b29b7e2a1c0433c5464d71fb07043a8931bcc4c9265bc55a465341d60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "595a810d86f0d8a14676cfe26ebd950fc3c4903369e3db4d4e9c6ab0cac27c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83faec24c563e4a91b12e702e5038ea8fe9e5176044dd62f4f1ada1de9acfc4f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    if OS.mac?
      kimi_code_prefix = libexec/"lib/node_modules/@moonshot-ai/kimi-code"
      node_modules = kimi_code_prefix/"node_modules"

      # Remove non-native architecture binaries from `node-pty` and `native`
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
      rm_r kimi_code_prefix/"native/darwin/prebuilds/darwin-#{other_arch}"

      # Strip universal binary to native architecture for `clipboard`
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end