class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.11.1.tgz"
  sha256 "f7de48495577a15a0e141fb0fd3fb2e335c53a1c6cd087295a2d22023f8cb723"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da78bafb3f533992cf9ff2dc110d04c3def5f257180959d116bb05bc6bf902d2"
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