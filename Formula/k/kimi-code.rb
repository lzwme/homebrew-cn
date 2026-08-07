class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.33.0.tgz"
  sha256 "49074364c4ef8d11adaf7823964e60a5152de472bdf0131c32e5d9d9f3e1e92c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b63ee129f03cb7a85f15b0bf463c951353a3448d94e25a7132500a4cec2cd69e"
    sha256 cellar: :any,                 arm64_sequoia: "b63ee129f03cb7a85f15b0bf463c951353a3448d94e25a7132500a4cec2cd69e"
    sha256 cellar: :any,                 arm64_sonoma:  "b63ee129f03cb7a85f15b0bf463c951353a3448d94e25a7132500a4cec2cd69e"
    sha256 cellar: :any,                 sonoma:        "c617204f5601c03751b8fc269ae33038be0a3b0426567f001d394fc8423d4235"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5049aa9468900933516cbcd5e3d5b6225e96cb7e5e22ae7ddbabc4a5e56d008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d0e46e7fcb648cf5737f8a00b9f7799960140194f0378d29281c14d8ed4f21e"
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