class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.23.0.tgz"
  sha256 "dc83e1d927fe5e86a97c625c4e55081373861d7ec4d18b38f34b3b6b38134cf7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06963880e65fa7b9b4bb296ea3f5dd65daa10c2afa6e8d6ba4299723fdc78c6b"
    sha256 cellar: :any,                 arm64_sequoia: "0d6dcb79d790766b4d2c5f2e1c27f535fceb7c66a451cb4e2d6cc65c3891374b"
    sha256 cellar: :any,                 arm64_sonoma:  "0d6dcb79d790766b4d2c5f2e1c27f535fceb7c66a451cb4e2d6cc65c3891374b"
    sha256 cellar: :any,                 sonoma:        "749ee6b13c927aa1d9b8da75126e2d8184ee65abb3200315f161f95eee531a30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53ef42089a918e43a8cc23ef71ff5728bca53e3007b4ce155e07a92e15457962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "999bb40c41a86d360a4542ffc3f8a2197a73f81fd6fce7d6a44c4835b40ff1ec"
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