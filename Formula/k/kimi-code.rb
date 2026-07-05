class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.22.2.tgz"
  sha256 "645ec7156e2a41cf167998aba35ecfb45c86fab6e3a0d96f690b9cccb052489d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0bf78c3c2e2e01b532de757c084021d436762b1c5b91928b694ba57ca65cda54"
    sha256 cellar: :any,                 arm64_sequoia: "384c643e5e56f1551745692ce7ec33ac654c237b7ed4879eb0a522902012683a"
    sha256 cellar: :any,                 arm64_sonoma:  "384c643e5e56f1551745692ce7ec33ac654c237b7ed4879eb0a522902012683a"
    sha256 cellar: :any,                 sonoma:        "730f969c65f87c60f964497799efc91941fc45d3c046f0edd4f3220274c56075"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf352743cef950a0265292bf91651eee2ae90eac0d51e6402dc2b90e8d6d9b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0480b7e5e114d779ebd65499a5789fc4aaf1a0150a3119b6cfe2ffc8cd35c67"
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