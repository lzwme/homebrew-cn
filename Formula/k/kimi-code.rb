class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.23.3.tgz"
  sha256 "04b37147af23a38758dfdf93776dc44726a4d13f20a6002ff4471ce20f0d74a7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "814ac39b36350bc981fb42efa8da39614fd89413a1a500f2b259b72169d1b054"
    sha256 cellar: :any,                 arm64_sequoia: "67d3f8f54409478b1839b77e5752dceb9fe7c4556b53c5b233614ebe17c6e36c"
    sha256 cellar: :any,                 arm64_sonoma:  "67d3f8f54409478b1839b77e5752dceb9fe7c4556b53c5b233614ebe17c6e36c"
    sha256 cellar: :any,                 sonoma:        "80ca965a39b58a43049a9a063829b6fca8c750df6a50a39f4a1c7caf5a15ec86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "980315d76121cc3942b4975afb9120bedb81e617798a359cc2fda7abfc282233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad047254241a84062e84f8b14dd5f970ddb724bd9d815194983ed21e1681b90"
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