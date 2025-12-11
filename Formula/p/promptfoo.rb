class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.3.tgz"
  sha256 "8e6386d6ae0b1ba8f60371b36757f0d9607a832b4fc817b2f2a704c15126cc15"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c57ca829bd48ca5e5c8f49258903c917477e7e7a60e4ea17812a954188d929fa"
    sha256 cellar: :any,                 arm64_sequoia: "821fca466dade14de756ec2c84a3db620ea36d1cdd7f40fc1dcaf26eae4ba954"
    sha256 cellar: :any,                 arm64_sonoma:  "db5b9e26c0d2653830d4db1bd1cd0474e577ebbe2a21543e8fff6e2c8a5252b5"
    sha256 cellar: :any,                 sonoma:        "a6e9d47743ffe9a03de046c7418173285c4ea524c7cde7ace2189be4c2d5d9c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b869d4e04febbe73f1c68bf10cb0a031d559043a4124eb1df71f05413b71ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80fb75a3a58860128e3ff3674ea7dd2b9b2067217a04ff92c8d39cd5496cd1f9"
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