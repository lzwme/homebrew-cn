class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.11.0.tgz"
  sha256 "bedf7619b15c8a80e5e0dddd45e809397d1c250f7c6710415b2fcd7a7ff785a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff9cfbcf40d7b5f1b41b077645f129f4f29d23ab8434a71ead8285f348bd73e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff9cfbcf40d7b5f1b41b077645f129f4f29d23ab8434a71ead8285f348bd73e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff9cfbcf40d7b5f1b41b077645f129f4f29d23ab8434a71ead8285f348bd73e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c1a587f17b966babcc72eb564858734efe33c17be79901797d11f06b2d27763"
    sha256 cellar: :any_skip_relocation, ventura:       "1c1a587f17b966babcc72eb564858734efe33c17be79901797d11f06b2d27763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff9cfbcf40d7b5f1b41b077645f129f4f29d23ab8434a71ead8285f348bd73e3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end