require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.8.0.tgz"
  sha256 "6953308aa17ac5b1383d080f3e82ef8fcca4d558be45f4c1d9c8a15fe271f1e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f75c51330e5f804e0023d9ac23a9283592cf5ca7c0a9d88584b41d52eba621d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f75c51330e5f804e0023d9ac23a9283592cf5ca7c0a9d88584b41d52eba621d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f75c51330e5f804e0023d9ac23a9283592cf5ca7c0a9d88584b41d52eba621d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "349c7cdd6aa11e6b180b80bbb59a921a3c30c0564d1a687decb86346ecb266b2"
    sha256 cellar: :any_skip_relocation, ventura:        "349c7cdd6aa11e6b180b80bbb59a921a3c30c0564d1a687decb86346ecb266b2"
    sha256 cellar: :any_skip_relocation, monterey:       "349c7cdd6aa11e6b180b80bbb59a921a3c30c0564d1a687decb86346ecb266b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90cdde64d205050f2218b6d05f3881bc8c90c934ee14d066dbe31156443c1cd3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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