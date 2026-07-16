class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.24.1.tgz"
  sha256 "0013efcf24d6fe74565813830fb6eaf316ed5dac5e5e4188203dde3eb3bbafdf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "186fc58a7960947b917bf1f12143107ba70a63565fbe287a1f36e4de6a9d7d41"
    sha256 cellar: :any,                 arm64_sequoia: "186fc58a7960947b917bf1f12143107ba70a63565fbe287a1f36e4de6a9d7d41"
    sha256 cellar: :any,                 arm64_sonoma:  "186fc58a7960947b917bf1f12143107ba70a63565fbe287a1f36e4de6a9d7d41"
    sha256 cellar: :any,                 sonoma:        "1b6b70160255be11861aef3bd317fc56e029b9ce26735094260862d1cec5aaa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "501c70f0d85ba1cc28083bdd7eb79a947b4f9f9cbec892b2db7c145fbe08d216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2398f047e4c9c393aa0bbd705dcaf60673468881ecb3d6f1f7c897cf22388d88"
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