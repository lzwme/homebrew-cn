class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.5.tgz"
  sha256 "f8b5f0ba1c667a44b1157a16b8d5bc5d27d8fcca3d8c5db4e455f524c40202f3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0c3b43e46707640769a71589846562a9ddf77131e3fbddf019f9f043f76a853"
    sha256 cellar: :any,                 arm64_sequoia: "d3c9607da34b174b33feb2153d58133f170d1f31f211b2cbbc235ba63ed4f432"
    sha256 cellar: :any,                 arm64_sonoma:  "ef7bab0425cc9a387c19c5276f5d22f76a64a09c0e57d0919302d9cfb92c69b8"
    sha256 cellar: :any,                 sonoma:        "56d80357560d20ada455de8d7192f6b91d70124076c577697e2938b4cae1d8fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "132a5208b37ab849b1b446d95aab4d03b677cafe22a06b552a849ebcad298dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8c623e66c11377af6b5c89ca640eebac5c39375b08a5b48af6e61ad9b9ebd9"
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