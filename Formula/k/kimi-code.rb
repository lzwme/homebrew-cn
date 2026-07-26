class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.29.1.tgz"
  sha256 "0a9189eb619565781b092e51106f355d0d52a9b59dc5e690cb57c89a5e0f033f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "635d4f07a06b72027e4e8b87a79cb322752a32fc7ce0ded0e3c510fcd0c54621"
    sha256 cellar: :any,                 arm64_sequoia: "635d4f07a06b72027e4e8b87a79cb322752a32fc7ce0ded0e3c510fcd0c54621"
    sha256 cellar: :any,                 arm64_sonoma:  "635d4f07a06b72027e4e8b87a79cb322752a32fc7ce0ded0e3c510fcd0c54621"
    sha256 cellar: :any,                 sonoma:        "ef052ce94edec6a96980376a7ff4b10a78acb010d6e2adb923be2351011aad86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdfd0ec9636847a18a2bcbb46e7ba91a579ff6750249d6a885c2d00a5a91fc46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c57f34b448760e6c12ae45f1aadbd2499abb12f6783c6edad90579f730a34bde"
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