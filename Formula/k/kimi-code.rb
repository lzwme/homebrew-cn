class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.22.3.tgz"
  sha256 "d6fbd17c0cdaaf5169d9bcde4efab36fdaf9e72a2c99bdecaacc7b4aff132953"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "43943b8a5841c639c3da8690a378c2d871141be16b7951d98204f97c6b87043a"
    sha256 cellar: :any,                 arm64_sequoia: "2987c76e968d078ceb808e8b0bdf26765ac5e688604f8b57ee57e9a3e8987df9"
    sha256 cellar: :any,                 arm64_sonoma:  "2987c76e968d078ceb808e8b0bdf26765ac5e688604f8b57ee57e9a3e8987df9"
    sha256 cellar: :any,                 sonoma:        "4070db4510cc46afd17c9664a9778d6e6cd9b62bd047bc1d00559f01f0c5906a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "148fbeb205bfcd6dcb04a92cd6c7d81459692895cff9af22d0743dde182118c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c787610375bf1b302a08f991daf8fba39ff5445c8c577273cf1df1377312521d"
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