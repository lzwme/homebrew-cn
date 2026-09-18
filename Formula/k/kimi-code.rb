class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.43.1.tgz"
  sha256 "2ac671a704bc4f4d6f0cd1ffcec76ab10f185c376aa7edd6b0450f210563603c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0eb564015efcb026712f4e88a12ef1377e59363cf5bf878678fb3f1e42bce6a3"
    sha256 cellar: :any, arm64_tahoe:       "0eb564015efcb026712f4e88a12ef1377e59363cf5bf878678fb3f1e42bce6a3"
    sha256 cellar: :any, arm64_sequoia:     "0eb564015efcb026712f4e88a12ef1377e59363cf5bf878678fb3f1e42bce6a3"
    sha256 cellar: :any, arm64_linux:       "ae1609fd5766e09e1ea3db4c1243871e0ca085b02b0a77f3bc4367c004ae38df"
    sha256 cellar: :any, x86_64_linux:      "ace2aa08fa28237038c9a801841858b4583c41e1353300bd3c44855c82f6791f"
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