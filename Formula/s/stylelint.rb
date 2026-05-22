class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.12.0.tgz"
  sha256 "45e8e63910805510faf78a4ee4b536448549c6a72d78f6f455aa62c1c5555bc9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5d1402134805befa912ae10ec8fca9d3f39761b1a0b301c053f27adda38af3fd"
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