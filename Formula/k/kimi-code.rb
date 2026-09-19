class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.0.0.tgz"
  sha256 "d1450598a1844d9bc204f07ae9fd3bb371e7df1ec841cf7c9e86bde7c09d3cd1"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "04401aa025426645a8054f63033c6eeb8bcf8249a6f1a05a4fb2c626c3e64fcd"
    sha256 cellar: :any, arm64_tahoe:       "04401aa025426645a8054f63033c6eeb8bcf8249a6f1a05a4fb2c626c3e64fcd"
    sha256 cellar: :any, arm64_sequoia:     "04401aa025426645a8054f63033c6eeb8bcf8249a6f1a05a4fb2c626c3e64fcd"
    sha256 cellar: :any, arm64_linux:       "3b0e27c4cf6e12f59c2ee26f715bf4f472a767ec93f2e2cc3ef39ce5e1c342cc"
    sha256 cellar: :any, x86_64_linux:      "f70a2432102ed31069b83716cfd65bf950ca15b2f9092794bdbedb898be32fab"
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