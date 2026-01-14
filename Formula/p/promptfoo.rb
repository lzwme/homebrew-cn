class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.13.tgz"
  sha256 "16be17031f22ddb5691e8733e725405620cc7487c73ab89a5ff304a5806018ac"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8219d074d363438344c490f81a9b45de5fc38e32482bfb67508e8561211a6359"
    sha256 cellar: :any,                 arm64_sequoia: "26e2db324a7dc7848fb8c3220601043c50c30bbdd69724a21375b5fc2805b3a0"
    sha256 cellar: :any,                 arm64_sonoma:  "ae88b70ffe406ac3b2f85fa7b3619e5b441cc889c151dea4679b634cce10618b"
    sha256 cellar: :any,                 sonoma:        "95765069309d2efd5426adea1adcea89df8e1048ba179a4dab466cc762aa145d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cee631c1341ba30d53d70150f7b8e11e0566908b23407d83dc11b10f2c8b8719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4b11118a8b1210e94c0dd6017d9d425f423a4c2cf6ccf276398322a0f91c74a"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

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