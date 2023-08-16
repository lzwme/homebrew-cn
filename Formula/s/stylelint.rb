require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.10.2.tgz"
  sha256 "93bf1a30ca697ebe02addd83013758d1c450903b594cc1f6f26e9dcb9e62f851"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3770ffdbee3325c28ebf31d21e1090634ef27618e78bfe6e1de0dd719527a60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3770ffdbee3325c28ebf31d21e1090634ef27618e78bfe6e1de0dd719527a60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3770ffdbee3325c28ebf31d21e1090634ef27618e78bfe6e1de0dd719527a60"
    sha256 cellar: :any_skip_relocation, ventura:        "18239443cc87e3257b462b14ae452848b7134f46ceed28888c27281f7f760eb5"
    sha256 cellar: :any_skip_relocation, monterey:       "18239443cc87e3257b462b14ae452848b7134f46ceed28888c27281f7f760eb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "18239443cc87e3257b462b14ae452848b7134f46ceed28888c27281f7f760eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7a86595bd57cec4a8716b74ba78a63f2772a73b5fde07f118f64a81f31a9236"
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