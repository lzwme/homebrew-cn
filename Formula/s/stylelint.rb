require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.8.1.tgz"
  sha256 "037fc1198af5f004966747d41a8c7959aecccb04ec7ecce5f4b9048c2c2ef902"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b792c1ad46feb1b116d9cfe83b1c89e3791351123d788533d739c8466a0f6926"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b792c1ad46feb1b116d9cfe83b1c89e3791351123d788533d739c8466a0f6926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b792c1ad46feb1b116d9cfe83b1c89e3791351123d788533d739c8466a0f6926"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6810185c00413562170931c6c2b7c263cbafb3196085514b7253094ca9e26fc"
    sha256 cellar: :any_skip_relocation, ventura:        "e6810185c00413562170931c6c2b7c263cbafb3196085514b7253094ca9e26fc"
    sha256 cellar: :any_skip_relocation, monterey:       "e6810185c00413562170931c6c2b7c263cbafb3196085514b7253094ca9e26fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71159261de6694a2d0a38c2e898df333af1d1ec03fbb291c8ad65c4caba2d032"
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