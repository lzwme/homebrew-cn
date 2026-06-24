class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.19.0.tgz"
  sha256 "66a0d40b0e0cf64fb6b449cf23b4456eb81cce7f9a222dbbb34ace4607dd579f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d29019e8c0dfaed0e93aaf2761f6aa6001b2b495af96b472e5703ba7f7444f89"
    sha256 cellar: :any,                 arm64_sequoia: "fad39cbc0e1ea7d6defe26b22856c6c9659a6df0b3f1f0b46498559902f5b920"
    sha256 cellar: :any,                 arm64_sonoma:  "fad39cbc0e1ea7d6defe26b22856c6c9659a6df0b3f1f0b46498559902f5b920"
    sha256 cellar: :any,                 sonoma:        "de997632868c7b89ca964da3548d92f533c37c0ceced6612fca0dd75f0a17e93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93b44de06fe3511de43d6f2055d374245ae5a5dd9ad9efc72e4db6d2d97ede0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d7784fb37f22b984a15b40025c6b9704b5ffe2bcbd589152c9194985311824d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    node_modules = libexec/"lib/node_modules/@moonshot-ai/kimi-code/node_modules"

    # Remove non-native architecture binaries from `koffi` and `node-pty`
    if OS.mac?
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"koffi/build/koffi/darwin_#{other_arch}"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
    elsif OS.linux?
      # koffi requires libc++ which is not available in Homebrew Linux;
      # remove all prebuilt native binaries to avoid audit/linkage failures
      rm_r node_modules/"koffi/build"
    end

    # Strip universal binary to native architecture for `clipboard`
    if OS.mac?
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end