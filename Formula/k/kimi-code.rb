class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.34.0.tgz"
  sha256 "d25042ca22f3bb60726c6e143b14fe53f76cec4e54e800eef79bdbb84db0a831"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b51e9ce487a16d7a76111571fe7532853ed049c314428c9c57d2f28334a95c4"
    sha256 cellar: :any,                 arm64_sequoia: "8b51e9ce487a16d7a76111571fe7532853ed049c314428c9c57d2f28334a95c4"
    sha256 cellar: :any,                 arm64_sonoma:  "8b51e9ce487a16d7a76111571fe7532853ed049c314428c9c57d2f28334a95c4"
    sha256 cellar: :any,                 sonoma:        "60c05f79cb1a3b3d3e624509976193f45aa45c606f9fed36158e821ded48c12e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb5046232d1c00bba4a93d8871374ece73f3727788a7fbfc0292be22cf5c3c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "187fa6172508404d75c83ab5231328fe481d32bc06f4f598d6b53e56a50de176"
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