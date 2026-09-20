class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.0.1.tgz"
  sha256 "5b0dfb03a3e5f79b0030888c6b69679459afe8f1dc1e4175d921fe5701dd3b3e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "161c1f23329c74ca28a69b7a2153629fefebff9193bb69505b6dbcb81c629461"
    sha256 cellar: :any, arm64_tahoe:       "161c1f23329c74ca28a69b7a2153629fefebff9193bb69505b6dbcb81c629461"
    sha256 cellar: :any, arm64_sequoia:     "161c1f23329c74ca28a69b7a2153629fefebff9193bb69505b6dbcb81c629461"
    sha256 cellar: :any, arm64_linux:       "2f570f996f33f1da5c02ef47552c4c6317c4084b7a654ae892a819a266317bf9"
    sha256 cellar: :any, x86_64_linux:      "b5ef737d61e5e2d71cc1a7b1b1831c39961b48e019ea1b164f94fa387502f45a"
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