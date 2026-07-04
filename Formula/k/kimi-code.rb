class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.22.1.tgz"
  sha256 "60d7bbe54d7430cb61353f183208bd4936f4d9ad0345efd490b9417a6855c794"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ea6348dddeed58ad280d9c0eb8c6c56f86b8ae61b9c97a18af2c2e3b47055de"
    sha256 cellar: :any,                 arm64_sequoia: "ae94a2af4a8a82e97d67b56d63ceb04f864b1d8f452257467cf32ca9d74f69ff"
    sha256 cellar: :any,                 arm64_sonoma:  "ae94a2af4a8a82e97d67b56d63ceb04f864b1d8f452257467cf32ca9d74f69ff"
    sha256 cellar: :any,                 sonoma:        "d46be7f49f0743338145ae021e171309c7573f7612965151ac2fc0b78caa319a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e93a38a1007c0abb2c5a49c7a0fff3d628cc7884f7f5680122338b872d9814e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f44bbf3b2e2194d4e3dd9611cd93cbe5464c2715a2d6638f7a3045669181c5"
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