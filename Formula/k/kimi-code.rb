class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.23.6.tgz"
  sha256 "e8fdd6f8e4d78b9e0aba77d333dbc7d09e8524080d48785b49ef49b3bdf5c305"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c63b475c7ad2acdfbc5e8c28fb4503a6f1e7ad8898c587f3b9f265c7c9b92048"
    sha256 cellar: :any,                 arm64_sequoia: "a19ecf40e65a42acc90d8229e0811f2da655dc289b1a8f790338b2541112de83"
    sha256 cellar: :any,                 arm64_sonoma:  "a19ecf40e65a42acc90d8229e0811f2da655dc289b1a8f790338b2541112de83"
    sha256 cellar: :any,                 sonoma:        "cfacb976715002e50ded8074c5c119f6b69a13f2cbb131b55af3eba6e3845906"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec9f4c2f7a9c4b46ac118c4818d92a86d17436345c4d467d5fc0bfac1a1bcaac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8cfcd05b64d6144c982055f5b2f07ac3a42e398572aed72964806b038cc4f1f"
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