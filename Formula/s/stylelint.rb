class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.16.0.tgz"
  sha256 "950b26ca89d53ea55cec1b8ca904ff6aa0d93007d360fe840dffdc174e148f66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad51441dd183b426410e116558ad5b1edd7b99d840a8f78922de5b98e0f646d4"
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