class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.24.2.tgz"
  sha256 "546e6cc010f86c8b7ed53805ade2ff7d643a3f68a33956a1a3606a0f1781bd51"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80f24573ccc32a8e800ac92eee954dc4355e39ac0210811fa552ebdc334d256a"
    sha256 cellar: :any,                 arm64_sequoia: "80f24573ccc32a8e800ac92eee954dc4355e39ac0210811fa552ebdc334d256a"
    sha256 cellar: :any,                 arm64_sonoma:  "80f24573ccc32a8e800ac92eee954dc4355e39ac0210811fa552ebdc334d256a"
    sha256 cellar: :any,                 sonoma:        "37f550334c812050380e5b20de850b99ca6c274997906e65465f2e5e7ff18934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5331d766f6a13dc71063aa167f33c6e9e1ce4cf3543f11d190af0f13c3ea50bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d793d3d0dc98ddba98547b80cca862953432a422163104a61db817565a5dd65"
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