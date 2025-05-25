class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.113.3.tgz"
  sha256 "8a7ef22428cc1524f95aeb97d1ffc20f4081157090131ec1013e1fa6367b4422"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1a78621409f5b302e3dc86bbb331121bafc22eeafdaa7b61edf31b925533b113"
    sha256 cellar: :any,                 arm64_sonoma:  "61eb5becc5a5f245ced676b5a4ff95f2d2f7c8bd986dcd2e7287d7c439bf7ce1"
    sha256 cellar: :any,                 arm64_ventura: "7f8085d8097a781cf3c82eb5557a5476b1055c18a25f2971e840b0b0a3bebded"
    sha256                               sonoma:        "7d8209a0aa12569664b22b683dd610bcca0ff23fa44b84ba8e2056d88a2b39a7"
    sha256                               ventura:       "97901d908904cae5e9a837f3da38c2c4a1664366e5054eb1ba6e6885931db97f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f47ccd08a2ec304c2b4405ca98f52eda9448ffa4a734b02bb216e0c998414b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74a0453f5945dddcbf301eb8349c138043201578f3252cc4fb5c3d9a5d686a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end