class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.12.0.tgz"
  sha256 "f5e2927ec467c5bb34c9015da45f3e0cd364af6e867673731a5cae96805fa4aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c63ca56f29710d43a15820ac13c4674bafa6d43ac789bf4dc4020c5c65f30690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c63ca56f29710d43a15820ac13c4674bafa6d43ac789bf4dc4020c5c65f30690"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c63ca56f29710d43a15820ac13c4674bafa6d43ac789bf4dc4020c5c65f30690"
    sha256 cellar: :any_skip_relocation, sonoma:        "57a07be1c58a799210582e8cdfb08d117072860ad49d76c2075f1a4eaf6bdecc"
    sha256 cellar: :any_skip_relocation, ventura:       "57a07be1c58a799210582e8cdfb08d117072860ad49d76c2075f1a4eaf6bdecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c63ca56f29710d43a15820ac13c4674bafa6d43ac789bf4dc4020c5c65f30690"
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