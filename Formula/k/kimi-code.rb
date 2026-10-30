class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.4.0.tgz"
  sha256 "1037267384134ad8901ea4fe62ee7a840fb7ec394ee381fe8f2046011586bb7a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "49a22445b068288bcbf08492e0422d573292ff6da85fdb2c44a42b65ebb3c57a"
    sha256 cellar: :any, arm64_tahoe:       "49a22445b068288bcbf08492e0422d573292ff6da85fdb2c44a42b65ebb3c57a"
    sha256 cellar: :any, arm64_sequoia:     "49a22445b068288bcbf08492e0422d573292ff6da85fdb2c44a42b65ebb3c57a"
    sha256 cellar: :any, arm64_linux:       "40dc0c2e835188c0bf400747c2634b42ef238e6e261b6fdaa8df7f27d9361dca"
    sha256 cellar: :any, x86_64_linux:      "6d1d49e33dabbd408775bebcb5e89d6cd7dea1dcc5a2d6ae30a33d5b85d71814"
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

    # Remove non-native architecture binaries from `native`
    other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
    os = OS.kernel_name.downcase
    rm_r kimi_code_prefix/"native/#{os}/prebuilds/#{os}-#{other_arch}"

    if OS.mac?
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