require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.54.0.tgz"
  sha256 "1a14cb15cae555c5c8f422d177d13a3cc6a15b853f930440e4c9ba505381dcd2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e5350b1c4cb2a7dc9e2ceea4a28dcab7505fe3e98c87d04505aa5d9f7a05f87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e5350b1c4cb2a7dc9e2ceea4a28dcab7505fe3e98c87d04505aa5d9f7a05f87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e5350b1c4cb2a7dc9e2ceea4a28dcab7505fe3e98c87d04505aa5d9f7a05f87"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef9bd57a58661376ec266b02be8411d90595045ed2c90abc0bcf6db5e7c8f354"
    sha256 cellar: :any_skip_relocation, ventura:        "ef9bd57a58661376ec266b02be8411d90595045ed2c90abc0bcf6db5e7c8f354"
    sha256 cellar: :any_skip_relocation, monterey:       "ef9bd57a58661376ec266b02be8411d90595045ed2c90abc0bcf6db5e7c8f354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e5350b1c4cb2a7dc9e2ceea4a28dcab7505fe3e98c87d04505aa5d9f7a05f87"
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