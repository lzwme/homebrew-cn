class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.17.0.tgz"
  sha256 "aaaa3473583ec4ee232b0e4ed1452b5cefd3fc488006939fd6d82740f78f907a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e9888aaced053951724a0af15185e14cb1d144d641569b0fcb23fac8111624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30e9888aaced053951724a0af15185e14cb1d144d641569b0fcb23fac8111624"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30e9888aaced053951724a0af15185e14cb1d144d641569b0fcb23fac8111624"
    sha256 cellar: :any_skip_relocation, sonoma:        "d10b40f2a48fee6f35d772455fb5d1f0f8180214d966c83875fb64c4db6ae9de"
    sha256 cellar: :any_skip_relocation, ventura:       "d10b40f2a48fee6f35d772455fb5d1f0f8180214d966c83875fb64c4db6ae9de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30e9888aaced053951724a0af15185e14cb1d144d641569b0fcb23fac8111624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30e9888aaced053951724a0af15185e14cb1d144d641569b0fcb23fac8111624"
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