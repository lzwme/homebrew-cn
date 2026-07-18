class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.26.0.tgz"
  sha256 "306b82fb1c046d359847644a987c62a016ad464aac3046d3cad0eece9cdfdd61"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82b12598c3a5a50b1ebffbb0c8997705acedc67827f3a3448104fd945a3edabc"
    sha256 cellar: :any,                 arm64_sequoia: "82b12598c3a5a50b1ebffbb0c8997705acedc67827f3a3448104fd945a3edabc"
    sha256 cellar: :any,                 arm64_sonoma:  "82b12598c3a5a50b1ebffbb0c8997705acedc67827f3a3448104fd945a3edabc"
    sha256 cellar: :any,                 sonoma:        "6c69ddd9e58d009a30e4dbbf788d7efa8c4eb04c43eb3c418e525c332a6f1e28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e81d56869117f06ff9842da40573a6855ee0a34a1914b3e03175dc7ec26d8bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3718908c5166462b71458331f98f6fb4894c601d8373562a93c8f1e1ec0e391b"
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