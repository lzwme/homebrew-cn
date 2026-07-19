class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.27.0.tgz"
  sha256 "a9cf6407b453ac69bad3d612baa6838a6e5dab680ca2e8bc7c24db140579aaa0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8e77b77b1d856d4253bf729b01c51b197faeb99e8ca1f12ad0862253730cd104"
    sha256 cellar: :any,                 arm64_sequoia: "8e77b77b1d856d4253bf729b01c51b197faeb99e8ca1f12ad0862253730cd104"
    sha256 cellar: :any,                 arm64_sonoma:  "8e77b77b1d856d4253bf729b01c51b197faeb99e8ca1f12ad0862253730cd104"
    sha256 cellar: :any,                 sonoma:        "6dce80171aacff7ec4ecc422354c7e091bf23f092b2b11ca1f650f61ec697020"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91fe3590eeba931ea3a3d921108099ac135fab293923f59d4edd8199ec9245c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "688b7b518178de741e4bbd5ccc883f1a107e1b29763c7532fd1cc57897c5b38e"
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