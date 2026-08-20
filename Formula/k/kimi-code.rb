class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.37.2.tgz"
  sha256 "7d5066c07724bd5e2f86b7136d85d3661469dded3a2b4d17c0755771cda7a7cc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38dff12c64be00c68dd9f1c4e3ac35c6a2f93586dd8099e27ac2ab2c5a26b424"
    sha256 cellar: :any,                 arm64_sequoia: "38dff12c64be00c68dd9f1c4e3ac35c6a2f93586dd8099e27ac2ab2c5a26b424"
    sha256 cellar: :any,                 arm64_sonoma:  "38dff12c64be00c68dd9f1c4e3ac35c6a2f93586dd8099e27ac2ab2c5a26b424"
    sha256 cellar: :any,                 sonoma:        "d21af98c34237abbd85bb71d1dc46ad09eb58496ab64897f800639bc4218e956"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93ef904471518951fd87562eb9483d11260a93b3d27f6ac325b1630c63949f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c83099f61fc009ce76efc3bd311a2d84f4b0160276a90805d20d65ffbeb2a55"
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