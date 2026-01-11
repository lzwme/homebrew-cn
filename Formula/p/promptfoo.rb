class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.120.11.tgz"
  sha256 "968593a62153460fc602d6d998709f940176938670c50257092161851574ef26"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5cbce6f69862bc0678d987c151676781d465b0e88f40057e1508915d8a35e649"
    sha256 cellar: :any,                 arm64_sequoia: "d99f539ce8a2e73d30ae040707680da3d63e75481719fc7267233124dd3ff1a7"
    sha256 cellar: :any,                 arm64_sonoma:  "a1f2d15c1c0f58efe246d9bfd6dffb65ccae354a19644da87ed0cf0c0b06c853"
    sha256 cellar: :any,                 sonoma:        "2ab24caf561971812d38752c5c1609510c80077915a9da80bc06fd2a35c63faf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3db4c413b00fea17c27b7e76e94cbce68e4f074b1633f9e2cbb504711a50ac3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdc94c93d3b23d96bacafdcb6e97a2066ccd6259e82382ef000c378b6561da32"
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