require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.37.0.tgz"
  sha256 "9086a3f4e785c00766d6421d412aaf45ce99281dca0323829990e51ac285a485"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae80bda97efee6043e66689256cadaa97d28c5da0d79bc2deeea41c54d254c6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae80bda97efee6043e66689256cadaa97d28c5da0d79bc2deeea41c54d254c6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae80bda97efee6043e66689256cadaa97d28c5da0d79bc2deeea41c54d254c6b"
    sha256 cellar: :any_skip_relocation, ventura:        "320554a492c2fb8dbfc9e31af674e36ff7b0e282e040980162e1d8cb0ca0c140"
    sha256 cellar: :any_skip_relocation, monterey:       "320554a492c2fb8dbfc9e31af674e36ff7b0e282e040980162e1d8cb0ca0c140"
    sha256 cellar: :any_skip_relocation, big_sur:        "320554a492c2fb8dbfc9e31af674e36ff7b0e282e040980162e1d8cb0ca0c140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae80bda97efee6043e66689256cadaa97d28c5da0d79bc2deeea41c54d254c6b"
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