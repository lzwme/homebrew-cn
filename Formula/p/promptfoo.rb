class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.15.tgz"
  sha256 "719646d44c2b16b82a061eb9c1933458dade4558a1e163ef56aadde4d3b747ff"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88206d36873de4837e33346c9b3a9d843307ec8af979a4f880a06535d8250f16"
    sha256 cellar: :any,                 arm64_sequoia: "eded7dc0c5d4c444375d6cb1cbce821f4fa5cf0c8a3e9b35e66281b23faa2e28"
    sha256 cellar: :any,                 arm64_sonoma:  "4d9a38e543235877c76076a43aee9aa810e6e1efdc361e2205cdb53f76a610fa"
    sha256 cellar: :any,                 sonoma:        "56b849b6d83384b001a4e5a7390ed7a69a131a27da2630645b7c19a2e203a1a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d86f151ecf94c27818c2f07cfbf28dccfd5c6da46507f89adcc93e7fd198e9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d11d5c2b708cab70063b7d962966c707770b051cb9b1af9a059de22e9af4cc7"
  end

  depends_on "node"

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