require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.52.0.tgz"
  sha256 "4cceb9bf0440f42dbc6e8758b0bd4920f1e5deb13734db8e3d9192ee9899e6e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5ab4eadbd4dc0c66fe595b48aa8653083ad4ee4aa11001c2f988015ce41ed04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5ab4eadbd4dc0c66fe595b48aa8653083ad4ee4aa11001c2f988015ce41ed04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5ab4eadbd4dc0c66fe595b48aa8653083ad4ee4aa11001c2f988015ce41ed04"
    sha256 cellar: :any_skip_relocation, sonoma:         "95090135fe17e4883d1da32a0665c4f1dd9e299bbe87a2a5aa92b409f4c76a7a"
    sha256 cellar: :any_skip_relocation, ventura:        "95090135fe17e4883d1da32a0665c4f1dd9e299bbe87a2a5aa92b409f4c76a7a"
    sha256 cellar: :any_skip_relocation, monterey:       "95090135fe17e4883d1da32a0665c4f1dd9e299bbe87a2a5aa92b409f4c76a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5ab4eadbd4dc0c66fe595b48aa8653083ad4ee4aa11001c2f988015ce41ed04"
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