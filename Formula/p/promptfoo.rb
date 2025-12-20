class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.7.tgz"
  sha256 "3418e332e146634d21e9bf62445ddf75eabbd4fea967ef07127920750589a1f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc97023854e3442afb456c396a863d34227d85637d8aabe6f110a4e94ea9d4f2"
    sha256 cellar: :any,                 arm64_sequoia: "961e0b3ff5b71b7e3a642efba192ee649d912338a1e185951ae59667071dddbb"
    sha256 cellar: :any,                 arm64_sonoma:  "04834e48f92f110631d2acfd4fc04ccea427e7dd5e2c566278aeb0e7d7fa50e1"
    sha256 cellar: :any,                 sonoma:        "1b3c60b1969631391dcdf19c38a9547999c403df08e7574baf405ac02aeb9296"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "482f291a8c692ef49fe52b71390402e43c6fc2dd6a2324a0bc6015c362d755d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42e3b31fb46dbc0f477f9d35bd4065af5cd191b2f3ac843baca539e2847ca718"
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