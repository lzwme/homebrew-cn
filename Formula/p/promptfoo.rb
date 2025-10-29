class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.0.tgz"
  sha256 "e016fc4b03cf92babdd3ce79daefec69edb542698b886fc49af98298965c6249"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1434c5b2f77da328ce7f8771988afb0a36d66efcc89da96d7ba7f2d5e65892c3"
    sha256 cellar: :any,                 arm64_sequoia: "aa07c31262998b7b6023d846a146acf525ff24e22df0ebdfa2fc5a894e06d201"
    sha256 cellar: :any,                 arm64_sonoma:  "e3ed85975239e18fe8bd426e5f59a53d1d8c4d548f5bfe378628bcca7a07bcd8"
    sha256 cellar: :any,                 sonoma:        "0d63c42f397626e082b09f35fd1316ce6d9326d2d68ce1251b2f8e7c64d8cd4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "257375767e5891a3b8949bab602600689cbb0a7dbf18d4377c31d66715b7452b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a750efb252f93f375f105a0307e09097ed7a320e8e9592b767de9b6df9bbdb92"
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