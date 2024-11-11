class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.96.0.tgz"
  sha256 "6aab0b01eae678c7c1538330609f9febdcc5fe2a43301e57222a2f9e0ab68eec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f2ac0d522d962649ae9879dc83b88ebcedb23783e8c38609776032d140613e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f10f49ed7f242295b3d6249e0678acbe80eae01589a3d393316476b435942a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd4ad6534bc405af729a59eb147299b2db6a1829bf5b66606eb0e2f8da836353"
    sha256 cellar: :any_skip_relocation, sonoma:        "663763dedc4dfa287e506e1d9c4894a504e90f9ca590ce958f503cc59b16d494"
    sha256 cellar: :any_skip_relocation, ventura:       "ad0897bb088707434368c65aa8eb77b827d524990e5c53d75a3b0dc81507890b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fec06eb0b423fe4bd7c8df5dd3e914ee21453953c9669fedcf54841ead45ee6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end