require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.46.0.tgz"
  sha256 "57a6999c35f738944da92439c1a72818559a9208d9c16924ace16c5228485b64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d7b3e145c8131fe6e0190d4586305c6378022ecf56c690eb5abacd4da9fb9a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d7b3e145c8131fe6e0190d4586305c6378022ecf56c690eb5abacd4da9fb9a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d7b3e145c8131fe6e0190d4586305c6378022ecf56c690eb5abacd4da9fb9a2"
    sha256 cellar: :any_skip_relocation, ventura:        "33bb49c6782f14c99a330d38edd11a67c3c0c68d7e340764587f144362ae8283"
    sha256 cellar: :any_skip_relocation, monterey:       "33bb49c6782f14c99a330d38edd11a67c3c0c68d7e340764587f144362ae8283"
    sha256 cellar: :any_skip_relocation, big_sur:        "33bb49c6782f14c99a330d38edd11a67c3c0c68d7e340764587f144362ae8283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39a2eb3de7c6562ae4e3527b14c68855eef759586fb2a060bda96ddcad943896"
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