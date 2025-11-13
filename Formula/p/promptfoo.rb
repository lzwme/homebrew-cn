class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.6.tgz"
  sha256 "40f6db383c7a9da0e17b0c8241429188aa56175f15f1334d4dcbb187cba865f5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77e0210e67df13053fe78ce9b8997bbe82aa4de1a1a089bbc5b295dc4e19f481"
    sha256 cellar: :any,                 arm64_sequoia: "a969b113790ade78f236710c5fe92be75c3287650348e5615d8169143e1c1965"
    sha256 cellar: :any,                 arm64_sonoma:  "be12861321bf122a7bb294f1926e78ac24f97958a2ca9695af315b657676b710"
    sha256 cellar: :any,                 sonoma:        "a6c9eb071323f4ab0c9e40dbd0dc4d8c83176406d8aec0de1da8974d981c8190"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f92fc207fc12aceb58281ce1e11c02bce9b402defeb203affd4e4408f5a616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a38e846623e351ee32729ed1b7730ce986797b14c53fd59ecd32f8ad1f42f6"
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