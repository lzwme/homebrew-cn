class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.3.3.tgz"
  sha256 "3fa0f6ee8f0398c9af4cb6fd4859acf3ace847a93877c93073172eb350fd2d02"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "423b20c0f0298003d7b87d13120f26676b8e8d4f6295070eeeeda7d5aa57258c"
    sha256 cellar: :any, arm64_tahoe:       "423b20c0f0298003d7b87d13120f26676b8e8d4f6295070eeeeda7d5aa57258c"
    sha256 cellar: :any, arm64_sequoia:     "423b20c0f0298003d7b87d13120f26676b8e8d4f6295070eeeeda7d5aa57258c"
    sha256 cellar: :any, arm64_linux:       "2b2827c40512a28541b44bcf8e5f48bf4579e393015d234ad56034e3edad956e"
    sha256 cellar: :any, x86_64_linux:      "49cf4f0c65c95459350c03886de9331fe465ea9ce287c6fab2a32ce672f6cd2e"
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