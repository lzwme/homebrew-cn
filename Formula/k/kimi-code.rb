class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.3.0.tgz"
  sha256 "cc2202471bd6fe9c37431d3e6d1c1022aa55999f6646f0fe658ae45cfa708785"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c737e9a456ea5d088e237d2df1de866d7a1ef7e9bc6e1f6d5ef0e2d5c2c7770e"
    sha256 cellar: :any, arm64_tahoe:       "c737e9a456ea5d088e237d2df1de866d7a1ef7e9bc6e1f6d5ef0e2d5c2c7770e"
    sha256 cellar: :any, arm64_sequoia:     "c737e9a456ea5d088e237d2df1de866d7a1ef7e9bc6e1f6d5ef0e2d5c2c7770e"
    sha256 cellar: :any, arm64_linux:       "e9ad1ae441f22c6f4291088c4d2c9f8ca311a9fc51e68759fdc3763042ea2e30"
    sha256 cellar: :any, x86_64_linux:      "ca61dd47d0b14a04637cef7a015c8e87428212bc0f0a92322febfd31684144f8"
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