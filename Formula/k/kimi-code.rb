class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.36.1.tgz"
  sha256 "51a17caf5bbc7f5eb0c78b6957cffcb88a99d46ae405674d9ee26285198db6eb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33cdb18225652f6b96560b3993034eca259b095268d719f74d4e36a31bb71f06"
    sha256 cellar: :any,                 arm64_sequoia: "33cdb18225652f6b96560b3993034eca259b095268d719f74d4e36a31bb71f06"
    sha256 cellar: :any,                 arm64_sonoma:  "33cdb18225652f6b96560b3993034eca259b095268d719f74d4e36a31bb71f06"
    sha256 cellar: :any,                 sonoma:        "0193e8a311bc7b275e27f2330f35e28e4848cdb1061af74444b72d7d01a13c9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "442a5ce52f30b4fd2fdaa1bc5a20863f95bf57438d9ec3e67461c2a70fa08a19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a8e4364bdb65aecb7f62304e37b5d9d51e54417f2232f1139d435517a780ed6"
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