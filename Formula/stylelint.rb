require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.2.0.tgz"
  sha256 "5c2b04f5cb0fac612963b1f36e50d22ea4ec0a708720896ebd1e015f42f6903d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4232ad61e813c5f33cd7076fa5e27f594bad105b4ef73f10792f6e8ba84166c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4232ad61e813c5f33cd7076fa5e27f594bad105b4ef73f10792f6e8ba84166c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4232ad61e813c5f33cd7076fa5e27f594bad105b4ef73f10792f6e8ba84166c"
    sha256 cellar: :any_skip_relocation, ventura:        "6a00b7768f3ee2d7468d4b4f4983a190a80df979e43777935422693387d672af"
    sha256 cellar: :any_skip_relocation, monterey:       "6a00b7768f3ee2d7468d4b4f4983a190a80df979e43777935422693387d672af"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a00b7768f3ee2d7468d4b4f4983a190a80df979e43777935422693387d672af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4232ad61e813c5f33cd7076fa5e27f594bad105b4ef73f10792f6e8ba84166c"
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