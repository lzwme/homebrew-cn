require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.10.0.tgz"
  sha256 "6893c11104cfdc796343664ded5a1b8d3c8e7dda8a3ffa6ae4bd342e43fa49b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26ddbeb66be5df88bd0f7d4f669b4ea4f4ba9cc1923c456e70ef9f1dbee42dfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26ddbeb66be5df88bd0f7d4f669b4ea4f4ba9cc1923c456e70ef9f1dbee42dfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26ddbeb66be5df88bd0f7d4f669b4ea4f4ba9cc1923c456e70ef9f1dbee42dfe"
    sha256 cellar: :any_skip_relocation, ventura:        "7ed9ad568e9491fdc30deba2552b4f6cfe19bbeabd4a91bdd4eff6b364f59d19"
    sha256 cellar: :any_skip_relocation, monterey:       "7ed9ad568e9491fdc30deba2552b4f6cfe19bbeabd4a91bdd4eff6b364f59d19"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ed9ad568e9491fdc30deba2552b4f6cfe19bbeabd4a91bdd4eff6b364f59d19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26ddbeb66be5df88bd0f7d4f669b4ea4f4ba9cc1923c456e70ef9f1dbee42dfe"
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