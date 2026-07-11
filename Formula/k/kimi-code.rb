class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.23.4.tgz"
  sha256 "0377aecff1e0ecde6faa496310c51d6326da221f0a83b718fdf71ce6f0bf6e79"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b529cff6cbc1a559a6a7227b9513d463f65f83193fb84733fbfe6dc227f7bc7a"
    sha256 cellar: :any,                 arm64_sequoia: "75c30a32b398ee54e949810124bdc2b3a7ae85a5dc0aad8ccc314b233da66ba6"
    sha256 cellar: :any,                 arm64_sonoma:  "75c30a32b398ee54e949810124bdc2b3a7ae85a5dc0aad8ccc314b233da66ba6"
    sha256 cellar: :any,                 sonoma:        "64fda8779fcfe4958f410c144d32e2642795732a80d7738b9ef7a7acac7807ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5a5ed30dc9a99622bf88318643142a0047b8117be670811c4fbed6eb3211d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01a7dc62a4e01731c517fdb6d83a8838d90a72b5801513ad7fb0e7c28060e1d9"
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