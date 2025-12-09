class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.1.tgz"
  sha256 "0d507065e7e598846aa629f2054bb9ae0839eda75828745da68a5c6718489f27"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bac3320069876bb383af5505163c05c119a95c2af0282c14e2354c225fe9e566"
    sha256 cellar: :any,                 arm64_sequoia: "a0469e98cf70824977ea46a39acae32a3938cc3609158da62aa8f94291aaa074"
    sha256 cellar: :any,                 arm64_sonoma:  "5e1fdbbe638d7a93a2256e7ca5cad584b5894411a97fd2e7a2462e2b693076ab"
    sha256 cellar: :any,                 sonoma:        "67c16353626b4f327e27ac989a6aa28955915e82508a6f1957317394553aa56b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be32d5e30dd85b56cca57e6d6295212aa9fa743c565e1a070c79868474eff6d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f0599bd8cd7c5ee61fea2ee1dd6d69ae26f4e198176e717aff70b03ccdb18fb"
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