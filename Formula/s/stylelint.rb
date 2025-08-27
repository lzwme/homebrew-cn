class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.23.1.tgz"
  sha256 "5082dbb5e22ba2782756d91672e2e021819cf4865956bf151817c39585d37513"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6d1aab421b85c80c29c05825fb8cea0e8d0b2bb0aae539d62d34d70e03e8c5bf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end