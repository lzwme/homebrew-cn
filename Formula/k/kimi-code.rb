class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.36.0.tgz"
  sha256 "5e65aef9252d1b0c68e371f8aa4588d6361796372b7afe175f22ff46d9fc31f6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fca9c99da4987f8a73287c968a090248dad844cbbbb4a33924fa0be2c636a3b2"
    sha256 cellar: :any,                 arm64_sequoia: "fca9c99da4987f8a73287c968a090248dad844cbbbb4a33924fa0be2c636a3b2"
    sha256 cellar: :any,                 arm64_sonoma:  "fca9c99da4987f8a73287c968a090248dad844cbbbb4a33924fa0be2c636a3b2"
    sha256 cellar: :any,                 sonoma:        "5d6149f22e9b0c948b79f0ae31a6115d9ee749c7cb4b6c33aa1255d934b26c87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18a8d7697316089c6637c9644d61e95b0547a99744db9ea47d7c667c9894e1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ffc5fcc78efea9cbe2a80816578c98cc481286354732a2ce6ec38a03d6d499c"
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