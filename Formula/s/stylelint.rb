class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-17.1.0.tgz"
  sha256 "2eb38fb1dcccf7e5bf5acb1ea10de07ca12ac0266f7225d69e19b501d2eef287"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "37cbdaa01dc53911ac1f4211e687e5f02bd577ba6ca56e57689eb717753b2db8"
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
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end