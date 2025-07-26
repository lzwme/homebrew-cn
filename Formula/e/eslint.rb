class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.32.0.tgz"
  sha256 "d03cca2e3a0aa856667b83c8f949bc32539e270ea172eff1c023293ce6a33267"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d8c96a787cf262ac6747ef3400c34a2141a535fdc6767c7940433d451d066e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d8c96a787cf262ac6747ef3400c34a2141a535fdc6767c7940433d451d066e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d8c96a787cf262ac6747ef3400c34a2141a535fdc6767c7940433d451d066e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "298887f569292147140e76b19c8046df73eb6e153eab50fa6668686d08276171"
    sha256 cellar: :any_skip_relocation, ventura:       "298887f569292147140e76b19c8046df73eb6e153eab50fa6668686d08276171"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d8c96a787cf262ac6747ef3400c34a2141a535fdc6767c7940433d451d066e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d8c96a787cf262ac6747ef3400c34a2141a535fdc6767c7940433d451d066e7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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