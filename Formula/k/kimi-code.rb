class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.28.1.tgz"
  sha256 "aafbea0441eef5dae3f752accd51713341039fd1c117d166835609e641e094b9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "877b97d39c826a4bba9889a273f058bf5fdcb3ca3569fdc1a919d8ab7114a118"
    sha256 cellar: :any,                 arm64_sequoia: "877b97d39c826a4bba9889a273f058bf5fdcb3ca3569fdc1a919d8ab7114a118"
    sha256 cellar: :any,                 arm64_sonoma:  "877b97d39c826a4bba9889a273f058bf5fdcb3ca3569fdc1a919d8ab7114a118"
    sha256 cellar: :any,                 sonoma:        "5c31b23545b190504b92a4fc6d2859c9cdd51dbf072eb125e23b31f8556507ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91194153a906a3e00cd0226325d88137edcde9dfe33fe202fe5ed030a5b224a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a722d3ca49d105368e0af8c66cf3c632970b1ed4b083a749d6b4acf3e80927dd"
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