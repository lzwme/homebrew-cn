class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.8.1.tgz"
  sha256 "037fc1198af5f004966747d41a8c7959aecccb04ec7ecce5f4b9048c2c2ef902"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "994b32770db99f5c4d9d005dc6e53751b099f94261b3a8b513148613a3b1446b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "994b32770db99f5c4d9d005dc6e53751b099f94261b3a8b513148613a3b1446b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "994b32770db99f5c4d9d005dc6e53751b099f94261b3a8b513148613a3b1446b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cd5b21f8686f2521289b76a092dcc098740a2f859a88e5ba301e521a3bf4289"
    sha256 cellar: :any_skip_relocation, ventura:        "3cd5b21f8686f2521289b76a092dcc098740a2f859a88e5ba301e521a3bf4289"
    sha256 cellar: :any_skip_relocation, monterey:       "3cd5b21f8686f2521289b76a092dcc098740a2f859a88e5ba301e521a3bf4289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30db50f9d32570661ecea21e3aa7675403019e9789c3642ea6e0e6be52571248"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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