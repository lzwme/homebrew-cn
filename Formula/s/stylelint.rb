class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.23.1.tgz"
  sha256 "5082dbb5e22ba2782756d91672e2e021819cf4865956bf151817c39585d37513"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e715df289674423fe88abc5f6bdaf37704380453dbdf538d6fbe8c067399fcea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e715df289674423fe88abc5f6bdaf37704380453dbdf538d6fbe8c067399fcea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e715df289674423fe88abc5f6bdaf37704380453dbdf538d6fbe8c067399fcea"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f4bf192034474149478377a7960301465039de7f7064f5ca273135c5d60ac81"
    sha256 cellar: :any_skip_relocation, ventura:       "5f4bf192034474149478377a7960301465039de7f7064f5ca273135c5d60ac81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e715df289674423fe88abc5f6bdaf37704380453dbdf538d6fbe8c067399fcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e715df289674423fe88abc5f6bdaf37704380453dbdf538d6fbe8c067399fcea"
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