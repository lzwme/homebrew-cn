class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.3.1.tgz"
  sha256 "55ac1db0452e6646ff50e3f83916bcbb7d48a157622d1e5110497d52b26f79e7"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ef2cf0e6495a3ea503f29a238473c56c9fa1f36f5c0d7f68f2d753756bc8cc7f"
    sha256 cellar: :any, arm64_tahoe:       "ef2cf0e6495a3ea503f29a238473c56c9fa1f36f5c0d7f68f2d753756bc8cc7f"
    sha256 cellar: :any, arm64_sequoia:     "ef2cf0e6495a3ea503f29a238473c56c9fa1f36f5c0d7f68f2d753756bc8cc7f"
    sha256 cellar: :any, arm64_linux:       "7ae2efb734fdaee1151ac78f7a698912e429a6b93d2d01f288d75b70665f2316"
    sha256 cellar: :any, x86_64_linux:      "66ab15b4b1fb2ae554fcd97b24c69bdc9fcb6c72eef44fdb42f731eb1213c3fb"
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