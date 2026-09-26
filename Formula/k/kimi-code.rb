class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.1.1.tgz"
  sha256 "6690a29d7b5e14812754dd100136b7f4ee2577add8895f00fe27025b4412049f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "97552c4d8c5c8fce7526bc82120b311200b6f5ef9b2058a188722bcab671004e"
    sha256 cellar: :any, arm64_tahoe:       "97552c4d8c5c8fce7526bc82120b311200b6f5ef9b2058a188722bcab671004e"
    sha256 cellar: :any, arm64_sequoia:     "97552c4d8c5c8fce7526bc82120b311200b6f5ef9b2058a188722bcab671004e"
    sha256 cellar: :any, arm64_linux:       "b0c378bc35c18b89529a1c8bd308caf079fe3652b31e5ac66b746ff214f96b79"
    sha256 cellar: :any, x86_64_linux:      "048238018383157fdf0b0f2ee9a17303a7696fa33953eb8c90c9446636a6064b"
  end

  depends_on "node"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "libxcb"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    kimi_code_prefix = libexec/"lib/node_modules/@moonshot-ai/kimi-code"
    node_modules = kimi_code_prefix/"node_modules"

    # Remove non-native architecture binaries from `native` and `node-pty`
    other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
    os = OS.kernel_name.downcase
    rm_r kimi_code_prefix/"native/#{os}/prebuilds/#{os}-#{other_arch}"

    if OS.mac?
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"

      # Strip universal binary to native architecture for `clipboard`
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    else
      # Help the bundled native module find Homebrew's libxcb.
      Dir[kimi_code_prefix/"native/linux/prebuilds/*/*.node"].each do |native_module|
        system "patchelf", "--set-rpath", formula_opt_lib("libxcb"), native_module
      end
    end
  end

  test do
    # Chokidar's `fs.watch` crashes without FSEvents access in the macOS sandbox
    ENV["CHOKIDAR_USEPOLLING"] = "1" if OS.mac?

    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end