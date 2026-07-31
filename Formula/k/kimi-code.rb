class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.30.0.tgz"
  sha256 "44290ea95244435f447c9db10cc865de40ad08f8b09f4603b807d6bb462d3beb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "020ba090344fb911c7be7ddb413129addd4036c845a5de24f0557d0ee89014c9"
    sha256 cellar: :any,                 arm64_sequoia: "020ba090344fb911c7be7ddb413129addd4036c845a5de24f0557d0ee89014c9"
    sha256 cellar: :any,                 arm64_sonoma:  "020ba090344fb911c7be7ddb413129addd4036c845a5de24f0557d0ee89014c9"
    sha256 cellar: :any,                 sonoma:        "57edc16f7eed353e7cdb4646283a98ab990b897d00b0dd9797d7d9b524b319a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14d258e5412b570d5e15213d283191b5d25b88cc581d6077f2aadde21d1ad041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7edf7209b4486ec0aace1ba960de7396541a42d6fa25004ea9964712e116c489"
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