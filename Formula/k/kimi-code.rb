class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.23.5.tgz"
  sha256 "5eb2e4e961046821bef1dcf85e6de196710688ae17ea8f2b5a170309205ea048"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7c8761d5816205257fbdab217816ba48f97671b1f37d0a790cdbaf507b09bae"
    sha256 cellar: :any,                 arm64_sequoia: "63966a9b39d80cef7b9f82dc5732cec2a161c3219b1c0f8e6291ce5d3ff76bd3"
    sha256 cellar: :any,                 arm64_sonoma:  "63966a9b39d80cef7b9f82dc5732cec2a161c3219b1c0f8e6291ce5d3ff76bd3"
    sha256 cellar: :any,                 sonoma:        "373b5874569b449297ab309d1c638ffb73ff4a9717529581ea5f05563353743e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13fd257e253ad918ee3453a633bd35429b27bdffcf7df671c039227b05cc8513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b604b85e6b0665cb582b8bbc662bd1f24295253efbb69f28084b0c625ec8df"
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