class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.35.0.tgz"
  sha256 "94c7a4b4752fa56fdebfedc4345ff31ecaa5f635fd25740cf50ccd683705169e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb98616739647ca596398c4ddca68aac6624dc6c013577bfb16c13015d2616e1"
    sha256 cellar: :any,                 arm64_sequoia: "fb98616739647ca596398c4ddca68aac6624dc6c013577bfb16c13015d2616e1"
    sha256 cellar: :any,                 arm64_sonoma:  "fb98616739647ca596398c4ddca68aac6624dc6c013577bfb16c13015d2616e1"
    sha256 cellar: :any,                 sonoma:        "b646e9f81892f4f5cb8e5643f7e376e27cbf5d3582d37ae9b0a2bdff666319ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "034f7c094e663e58d10d24ed927b2ad433e94c10fee2646e09e9d8be85393583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18d5f83e25cb7d983c4540505c17e585285f2002e88333e5ed0dbe3b678631a"
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