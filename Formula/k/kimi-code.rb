class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.29.2.tgz"
  sha256 "2ec74d430990d853ff555480c01770415a79bf8987e3356f7e42ffb3791a53ab"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6faa73da49dce693707eacb5239b8166e4937de2a514da4bf663552a448f47e"
    sha256 cellar: :any,                 arm64_sequoia: "b6faa73da49dce693707eacb5239b8166e4937de2a514da4bf663552a448f47e"
    sha256 cellar: :any,                 arm64_sonoma:  "b6faa73da49dce693707eacb5239b8166e4937de2a514da4bf663552a448f47e"
    sha256 cellar: :any,                 sonoma:        "1078ab17c9d337ebad56ef1516ccf7fff0ef58af21c29fb23bd18b64df48a112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df06bea32e4b7c167940e44b31d2bbe8f7eeef2e6c67158759a09d35e3cc8142"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd1c82bc635fa7baced3e6e25371bac9d1931938c8a14b6917f36a9799978a73"
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