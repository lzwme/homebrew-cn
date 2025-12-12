class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.4.tgz"
  sha256 "4e663a6dfe7797f4d64242de94e817ed5df270e0bd48cd0d2c5f82a4e3e7bbd6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb66cc86e33cb8eeb1d0c7a435620c4004dfd977263f118a9b7ecb23576bb583"
    sha256 cellar: :any,                 arm64_sequoia: "c52c4b62b4d36a110f77a582dc50e50746624871952f472509286d2736fd0fa2"
    sha256 cellar: :any,                 arm64_sonoma:  "c9a07e20f635e1af2f6a2533543e475e1de2508fda1a78452db0935318dc8325"
    sha256 cellar: :any,                 sonoma:        "50db2cf52a88e5cb8f9642cc65138f877c0400c7c16edb1df28152283a583a77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0477884148e743cb33b0c7ee0511fca60e9720f6b71b7725b176e58fa7f49cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8bb3930e55809b98e2f5678462c9333ba342e740d88ea9f0ef2fc9c6f70110d"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    os = OS.mac? ? "apple-darwin" : "unknown-linux-musl"
    arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    rm_r(node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep")
    codex_vendor = node_modules/"@openai/codex-sdk/vendor"
    codex_vendor.children.each { |dir| rm_r dir if dir.basename.to_s != "#{arch}-#{os}" }
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end