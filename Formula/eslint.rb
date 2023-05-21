require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.41.0.tgz"
  sha256 "b0cd5d51fb4cf0f73cd59155d26b08a7878fde0f901f59c18f4bd3d14ff68d81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9c69c5e90b5c1338383ed1655d8e8e36fa26aef544ba1f40cf5bb3f40b7575a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9c69c5e90b5c1338383ed1655d8e8e36fa26aef544ba1f40cf5bb3f40b7575a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9c69c5e90b5c1338383ed1655d8e8e36fa26aef544ba1f40cf5bb3f40b7575a"
    sha256 cellar: :any_skip_relocation, ventura:        "537bf1f27ad0b335a9577132554bdd62b1d8449f30046c16701403553d005a7b"
    sha256 cellar: :any_skip_relocation, monterey:       "537bf1f27ad0b335a9577132554bdd62b1d8449f30046c16701403553d005a7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "537bf1f27ad0b335a9577132554bdd62b1d8449f30046c16701403553d005a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9c69c5e90b5c1338383ed1655d8e8e36fa26aef544ba1f40cf5bb3f40b7575a"
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