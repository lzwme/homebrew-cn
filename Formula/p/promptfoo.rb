class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.8.tgz"
  sha256 "f63434521fe49046d65b0d5bddb06315feda786111862773e1761f4dd67eee41"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bd9591fd833949517c5f6953d5ad85b5a7e424f6a58c46169d184356237a0b4"
    sha256 cellar: :any,                 arm64_sequoia: "646076588839acb323368faa6aa6c6f1628a79e72101cccd28671575b40ae10c"
    sha256 cellar: :any,                 arm64_sonoma:  "08453041b4220f2f340137d9d0fc4aa4adfa320ae60e10bb365fbb1da5af2e74"
    sha256 cellar: :any,                 sonoma:        "4e4e7a4c5c370cf997b41ff3a05cf024e9e7c7319005d035d04b2a6b811c0e98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "057c45bb5a7574e4ebdcfe7fee32416bc9985ad2cfcb8a0e881ddf97dd3b3d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae7c2dbb2ab6cf3a467d44e3c9e04d79f74e2cf3d024f46c407d64c38342279"
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