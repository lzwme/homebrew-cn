class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.10.tgz"
  sha256 "663f3f077b3d97854bd2f0ea69a10795634df836c7deeb48594293cef045978c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e275ad665e0afe3f4f152395302b583a10f0b3a64f269287f0c18ab0716d40a6"
    sha256 cellar: :any,                 arm64_sequoia: "e423cebf19553a4c7f083536653c0d6545406e8969cac62d3ea82723c86862fe"
    sha256 cellar: :any,                 arm64_sonoma:  "1677a7ec073135dbeac2d6419be1c7b3ee4c4311e0c686a2b6bf6de80616fd3f"
    sha256 cellar: :any,                 sonoma:        "146c8e3404bc4650a0caff2c36dc31daa23e4aa8ee4e601add4098e494dcfa91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a03dffae51bae19f26ca51901d202fb07814305595fa30119bb845f689ce42b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d4ccebcb0e35b453714c71bcaa17c4828fe0c4eb31054d73dc97472bdf45065"
  end

  depends_on "node"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version < 1700)

    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match 'description: "My eval"', (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end