require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.45.0.tgz"
  sha256 "56f6f570aa125ca9ed6848a0d19247bf1c9050c6b67b7478bd7be7b1d2fef366"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "104f6edd2902d918b171afbcd4be3b911dc828b2881b5d8353494de9c410957d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "104f6edd2902d918b171afbcd4be3b911dc828b2881b5d8353494de9c410957d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "104f6edd2902d918b171afbcd4be3b911dc828b2881b5d8353494de9c410957d"
    sha256 cellar: :any_skip_relocation, ventura:        "9aa216d09f008826f9d3ff76b8a8ec65bda04836e466fe7a03aaab95bf8c9b7c"
    sha256 cellar: :any_skip_relocation, monterey:       "9aa216d09f008826f9d3ff76b8a8ec65bda04836e466fe7a03aaab95bf8c9b7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9aa216d09f008826f9d3ff76b8a8ec65bda04836e466fe7a03aaab95bf8c9b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "104f6edd2902d918b171afbcd4be3b911dc828b2881b5d8353494de9c410957d"
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