class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.2.tgz"
  sha256 "ed3e06b849bd7f826f725d3128805307703d368aabb474a1f8c7e7a85d85843b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54b5b4ac1bda1f469d36227b8f2562c3f85140a1c0e27e54761797b26be9ac0f"
    sha256 cellar: :any,                 arm64_sequoia: "5e1a07770d9844c059330e66057ca01adbfe8a8711f94c64506f9e03515b3100"
    sha256 cellar: :any,                 arm64_sonoma:  "cefe497ed0e656928d0ae6198977047d898d4c648c69af3ca52c910b20efaa06"
    sha256 cellar: :any,                 sonoma:        "eb74c656c01a730686591954901bccd196dde245c52efcefb19739b43c3ed69f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7aa791b78a392840c3d5f527a298ec66eaf2003f0cc82ac9ca6d207dd1701570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b36395129ce7693baaf71b5b7ac3e00f7d6e6473f3fed4c7f28b0b1551ca02e4"
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