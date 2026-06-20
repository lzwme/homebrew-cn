class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.18.0.tgz"
  sha256 "4d9b03676d06b2ead23c1e1666c7bca2640c39992b6dae086eb407a187e01cd9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c61d3cba31a98d1758e4283f73f381092f90a7397fc6407f780d28bbba7b5d9"
    sha256 cellar: :any,                 arm64_sequoia: "6486bb110a1b7b8c32157d67b9fc5e8e66a0898e7d53665c77e3cc50d9978c09"
    sha256 cellar: :any,                 arm64_sonoma:  "6486bb110a1b7b8c32157d67b9fc5e8e66a0898e7d53665c77e3cc50d9978c09"
    sha256 cellar: :any,                 sonoma:        "234919b3ae5bc01b36a5653645467b6f2ae53c9394b87e7dacffb6f2f12a76e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a699310a8b03f5e8871881a3aa2e77612eb3a25f2f55632243e6396889cdfe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c78c29cac0c53113b30d2d238030314ee1cda983b9f3c622a3e04031eceabf"
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