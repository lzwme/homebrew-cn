class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.112.7.tgz"
  sha256 "ea889b3beeffc2563736860d0965906ee3a333b75e95a2f2429cdd1d76bc799c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0e674a141ba66666fdc3ac75e2438f3c5af8f26fb05437461243ddb730dc0b30"
    sha256 cellar: :any,                 arm64_sonoma:  "d7b8aa3e48760f5a472aa431b10a8649a39c08905684390d6eea47b5c396fe5d"
    sha256 cellar: :any,                 arm64_ventura: "083f6a3ab03c63801d3dd4a06587fc289d4bf9283aa8798f596110b16061c277"
    sha256                               sonoma:        "7b347f73f611ad51bab474aff3a4ef11f437388a72d86e9182731be72608f084"
    sha256                               ventura:       "c5463a1b90c14d76d771b82d6db365b8dd380ec69c20c8c784f37fdd1b51c2ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c37ef53ccafa5c69516a54f98695b2f1466be476b885f9871b06c9675e1d198a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1582446ee6c87ff5cd9970eb5d5b64f3dee15357995e36dd2e20687dd07be598"
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