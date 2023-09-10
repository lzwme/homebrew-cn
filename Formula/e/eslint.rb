require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.49.0.tgz"
  sha256 "7c6476c69cfe8adc47b2ce5ffb0d5aa20271f99885da565a23828163ea7e189a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "872bf53f786cb3d47f00778001f70d7ef3fa52a8ecd9016cebd6104a5ef46992"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "872bf53f786cb3d47f00778001f70d7ef3fa52a8ecd9016cebd6104a5ef46992"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "872bf53f786cb3d47f00778001f70d7ef3fa52a8ecd9016cebd6104a5ef46992"
    sha256 cellar: :any_skip_relocation, ventura:        "e95b8a14ed03cde12e4f937219a6dd5a67fde693af7be83634776224c545b4ce"
    sha256 cellar: :any_skip_relocation, monterey:       "e95b8a14ed03cde12e4f937219a6dd5a67fde693af7be83634776224c545b4ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "e95b8a14ed03cde12e4f937219a6dd5a67fde693af7be83634776224c545b4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872bf53f786cb3d47f00778001f70d7ef3fa52a8ecd9016cebd6104a5ef46992"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end