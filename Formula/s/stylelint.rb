class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.14.0.tgz"
  sha256 "224b1925cb5fdb741c710094aa9caa6c78ce97bedeb1a595d320c51a5dfc916d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe5f525e95e2581ec525bd0ec89f2efa7d14cd47ce1ef941057e15a59d003766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe5f525e95e2581ec525bd0ec89f2efa7d14cd47ce1ef941057e15a59d003766"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe5f525e95e2581ec525bd0ec89f2efa7d14cd47ce1ef941057e15a59d003766"
    sha256 cellar: :any_skip_relocation, sonoma:        "d77ee5362fdccb81c44a36fd77ad2f2f89672d1f3c7907a27a1171a42da346b9"
    sha256 cellar: :any_skip_relocation, ventura:       "d77ee5362fdccb81c44a36fd77ad2f2f89672d1f3c7907a27a1171a42da346b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe5f525e95e2581ec525bd0ec89f2efa7d14cd47ce1ef941057e15a59d003766"
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