class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.10.tgz"
  sha256 "5bf85fba31a0ef4b3363a14d549af2ea9dc5e63c4631e6398e49cdf2dea57e10"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0553faadd52879d56a10fba94f3d2faf9565a58dd883304fb4390201430827fa"
    sha256 cellar: :any,                 arm64_sequoia: "ea268eec5273c66a41a4c5e1f0e4806e1ef334eac0cc98faf87f4de2f933c701"
    sha256 cellar: :any,                 arm64_sonoma:  "9dc8e4830ccfe2ac8cf7c098c5e677f6e51591c6d343a28057449c66d0263205"
    sha256 cellar: :any,                 sonoma:        "2a2ff3f37c1a4cb2831dfc0bf94383a2c6c31e5fd259fe850e7b4d5ebe4d7180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f0c199c0e3079b32f2c90630602b308cb33aa0b668614b67f35085305788ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4756c2a61e670a0651883f910d384f2161498655b4d9202c7b243bd259325da"
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