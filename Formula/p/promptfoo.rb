class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.4.tgz"
  sha256 "127ff3642d6b9e3c82d180fe797f37f1cd13d239130b23f0768071c48aa2deac"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eff0318a1c89e3f8f5a9dc9301649b567e5e008686e7d04d15cc17f8f6a08a17"
    sha256 cellar: :any,                 arm64_sequoia: "44cb43576a66aa5611ce7f476a5062042b572f097cdd160f35125308a88bc600"
    sha256 cellar: :any,                 arm64_sonoma:  "1ad1b5059ce6508d41b79ef8bb4db48eb264729c0ff972a956dfdb3eef4a7562"
    sha256 cellar: :any,                 sonoma:        "18c684b0b1a5f99117ec993b7731a2263c0b5a382bee4858c1f9130f6e7c4579"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "652c95a49c783a05a3910beba6a6f13afe187eac823d4367c533f2d4b61477a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cf7492cd8118c215c51a7ef197b255e006fd24f0fd5ecb5d1d543caa582d68a"
  end

  depends_on "node@24"

  def install
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
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end