require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.8.0.tgz"
  sha256 "a6397da7187be44ff5a2aa83e5173c855bd39c5a7a3f1bd662cce3c03c60becb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48459ac405883603948fea3b26a6227fde37420e52644428a016cf0245e95437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48459ac405883603948fea3b26a6227fde37420e52644428a016cf0245e95437"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48459ac405883603948fea3b26a6227fde37420e52644428a016cf0245e95437"
    sha256 cellar: :any_skip_relocation, ventura:        "939b469f9340edae132cc0251940af995f48394ec9f6be1b3049003abb435a2a"
    sha256 cellar: :any_skip_relocation, monterey:       "939b469f9340edae132cc0251940af995f48394ec9f6be1b3049003abb435a2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "939b469f9340edae132cc0251940af995f48394ec9f6be1b3049003abb435a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48459ac405883603948fea3b26a6227fde37420e52644428a016cf0245e95437"
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