require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.55.0.tgz"
  sha256 "7f869453d27d0c66904521096b57193b9a1cd097bfecf546ea7e6be6e9001188"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b8c5af79c16bc40dd0dace86fdc01c4e6a0b34cdc0c39626c0d488ee09028ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b8c5af79c16bc40dd0dace86fdc01c4e6a0b34cdc0c39626c0d488ee09028ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b8c5af79c16bc40dd0dace86fdc01c4e6a0b34cdc0c39626c0d488ee09028ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "78a572df0321b140c2458dc9dd7622eda8523d5892828b466ce98baf46effb20"
    sha256 cellar: :any_skip_relocation, ventura:        "78a572df0321b140c2458dc9dd7622eda8523d5892828b466ce98baf46effb20"
    sha256 cellar: :any_skip_relocation, monterey:       "78a572df0321b140c2458dc9dd7622eda8523d5892828b466ce98baf46effb20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b8c5af79c16bc40dd0dace86fdc01c4e6a0b34cdc0c39626c0d488ee09028ec"
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