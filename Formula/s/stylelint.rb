class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.9.0.tgz"
  sha256 "8d2bea6367d235831e4a47d9a94879aba292b6a4cdc3688da408faa28d0dd313"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "85249b66c7ba3c4b86ce09b5bcf51682b152f711810612272db27b10e0131480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "036baccc05c1efe3c025231060d639f08347b26e6123e6c687b5b48f44040f0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "036baccc05c1efe3c025231060d639f08347b26e6123e6c687b5b48f44040f0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "036baccc05c1efe3c025231060d639f08347b26e6123e6c687b5b48f44040f0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d998ea187a121ff6bf3ce74bc829be1cb8d628a32b57a103d5ffd36c40dc6b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "d998ea187a121ff6bf3ce74bc829be1cb8d628a32b57a103d5ffd36c40dc6b6a"
    sha256 cellar: :any_skip_relocation, monterey:       "d998ea187a121ff6bf3ce74bc829be1cb8d628a32b57a103d5ffd36c40dc6b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "036baccc05c1efe3c025231060d639f08347b26e6123e6c687b5b48f44040f0b"
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