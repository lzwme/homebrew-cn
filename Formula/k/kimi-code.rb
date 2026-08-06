class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.32.0.tgz"
  sha256 "f69a4fb36400621b786e62b6253fdc6fe558c8fc499b98afe63d8c2cdde7485d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe09a0996c674258fa57593cb2f993473926d1cae4652d171b833c2727331bd2"
    sha256 cellar: :any,                 arm64_sequoia: "fe09a0996c674258fa57593cb2f993473926d1cae4652d171b833c2727331bd2"
    sha256 cellar: :any,                 arm64_sonoma:  "fe09a0996c674258fa57593cb2f993473926d1cae4652d171b833c2727331bd2"
    sha256 cellar: :any,                 sonoma:        "c27d855800a64bc561726c4257940bc9a7ca972f6ef9b9e96749825d1d7ca1d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baa774831378b304f662a8626d1e7469c51a108517f3451c2a02c2e204ec351e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a516e29d052a59806dd3a8e337c963642f06a3e66571a14dcb3b67bda04f749"
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