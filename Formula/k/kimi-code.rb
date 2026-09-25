class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.1.0.tgz"
  sha256 "25a081b7783806226434aab6c40462192d3f9e362391cba7b068af02d8b5fd71"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "154a4ea3331895d1ea5a71114d2d7fc63cd7ac516ca42d49e8535210619af1ac"
    sha256 cellar: :any, arm64_tahoe:       "154a4ea3331895d1ea5a71114d2d7fc63cd7ac516ca42d49e8535210619af1ac"
    sha256 cellar: :any, arm64_sequoia:     "154a4ea3331895d1ea5a71114d2d7fc63cd7ac516ca42d49e8535210619af1ac"
    sha256 cellar: :any, arm64_linux:       "20b5a6611ba892b9ff7ccaa2b356a1e1c59db35cd5406eaa86a8f57aab24e0ce"
    sha256 cellar: :any, x86_64_linux:      "49e66a2299437139f0e4f0a3db79b1d5824a48048090f25cbef6fb84224bc7c9"
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