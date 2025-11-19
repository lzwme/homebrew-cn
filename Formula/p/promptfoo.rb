class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.7.tgz"
  sha256 "df484562f7a4281a5fd8ce2673b259099a93ad76388a29786d23f3a4cba6288c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f13fd47b5d889c9e74ff6baacdc81f8be14b0b82da6ff69f806b3a9a8c7a0698"
    sha256 cellar: :any,                 arm64_sequoia: "8c62487766f2daefd5d298ce813f955f1cb847ce8b17aaa05d02415615b4983c"
    sha256 cellar: :any,                 arm64_sonoma:  "48f2bc710a5f6d1fa89fcfc5171f023bedc88ae06bbbd82ce7e861cc450d8820"
    sha256 cellar: :any,                 sonoma:        "e2870cab1afcb2cdd12d0304de8ae5855c6d27e73b78df25b8baf8be7b75cf15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "552ec60bfa9cdbbbb4e4d748470f56ae0f605457f3ad879f7703f0e3aea88df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b48ac5343f22f2296e7fb13aec4da064dd078821c0646d5dbd66f27f6b33dc8"
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