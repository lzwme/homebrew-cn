class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.31.1.tgz"
  sha256 "8ad7014b6d3d4c4767b86cb77b5e99902cea337a7c1511d74f47abd8247a74b4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab4e864e7c8173f6d8a2d2bf99d34396b514ed9c2e29f905afe970b43dc95c3f"
    sha256 cellar: :any,                 arm64_sequoia: "ab4e864e7c8173f6d8a2d2bf99d34396b514ed9c2e29f905afe970b43dc95c3f"
    sha256 cellar: :any,                 arm64_sonoma:  "ab4e864e7c8173f6d8a2d2bf99d34396b514ed9c2e29f905afe970b43dc95c3f"
    sha256 cellar: :any,                 sonoma:        "d4219e546b35fc8d09da60f3776fc8a99f7e1e038771c00c4e99b15c3e378bad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae34b4f127a171610252766edcad7bdef252e332bd7a1e01126cf223bb68bc63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "242b81566b35225d230fe6ba5d22e69492bef84c03b809000e564088ec0d1dca"
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