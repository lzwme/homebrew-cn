class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.7.0.tgz"
  sha256 "90f6821ffe9f709046ad6e821e0cd00c2d2f4483f49ac733c372b0dba0363630"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c9d7ac078a373ad322499e4d5cdc5ec55852eafa69e48894d669fcff2aa48bc2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/".stylelintrc").write <<~JSON
      {
        "rules": {
          "block-no-empty": true
        }
      }
    JSON

    (testpath/"test.css").write <<~CSS
      a {
      }
    CSS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end