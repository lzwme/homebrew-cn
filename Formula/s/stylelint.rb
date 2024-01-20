require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.2.0.tgz"
  sha256 "3759be7f4324d1c689cea46536d0435226471c26932015cc31fafa86a6718642"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "207380f3c903e24f500db448d33fee2a71491dfd696d30edac11e24675fe5d90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "207380f3c903e24f500db448d33fee2a71491dfd696d30edac11e24675fe5d90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207380f3c903e24f500db448d33fee2a71491dfd696d30edac11e24675fe5d90"
    sha256 cellar: :any_skip_relocation, sonoma:         "87a69f750d4a830df645a49559121f15e965d7b4ad6c75a09911c7e07781ae66"
    sha256 cellar: :any_skip_relocation, ventura:        "87a69f750d4a830df645a49559121f15e965d7b4ad6c75a09911c7e07781ae66"
    sha256 cellar: :any_skip_relocation, monterey:       "87a69f750d4a830df645a49559121f15e965d7b4ad6c75a09911c7e07781ae66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "207380f3c903e24f500db448d33fee2a71491dfd696d30edac11e24675fe5d90"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end