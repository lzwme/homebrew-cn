class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-2.3.2.tgz"
  sha256 "923cee1c84cd18c93c55ba4062270555256d081d7607d3e2b4babadc9e4deb0a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d38b217bff57e99c21c41b58ce0b68fee0f6f151c6b0bea3cb6a0216df129273"
    sha256 cellar: :any, arm64_tahoe:       "d38b217bff57e99c21c41b58ce0b68fee0f6f151c6b0bea3cb6a0216df129273"
    sha256 cellar: :any, arm64_sequoia:     "d38b217bff57e99c21c41b58ce0b68fee0f6f151c6b0bea3cb6a0216df129273"
    sha256 cellar: :any, arm64_linux:       "10e2473941e3b9b386f16be0beb1883832aac283e18cd0155f87b9d51bd42479"
    sha256 cellar: :any, x86_64_linux:      "30053abae954406dc1ce564d6eebd2cad9f7d940c89c4dc96cb20d81437d3d94"
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