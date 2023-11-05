require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.53.0.tgz"
  sha256 "0a585fff50f4871f250681cc37f20b0843c9b3dc1822bb9579f468ebc8f137e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06e13da13c1698c57e1531c81a7acd383b6642744078f24bcbf8a13beb9da4a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06e13da13c1698c57e1531c81a7acd383b6642744078f24bcbf8a13beb9da4a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06e13da13c1698c57e1531c81a7acd383b6642744078f24bcbf8a13beb9da4a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "73f2de9fb16f023d942220927ab703816c009352073d4b1b486cad10657fef07"
    sha256 cellar: :any_skip_relocation, ventura:        "73f2de9fb16f023d942220927ab703816c009352073d4b1b486cad10657fef07"
    sha256 cellar: :any_skip_relocation, monterey:       "73f2de9fb16f023d942220927ab703816c009352073d4b1b486cad10657fef07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06e13da13c1698c57e1531c81a7acd383b6642744078f24bcbf8a13beb9da4a4"
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