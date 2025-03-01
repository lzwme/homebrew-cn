class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.15.0.tgz"
  sha256 "8b5e5207cae176dcbffb2c3068bcf4ce35c197e5184c883d52ee2e336e15d334"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ffb62f11f6446cebdba4ec34af2974285ef911511c41d655e6171bba1bc66d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ffb62f11f6446cebdba4ec34af2974285ef911511c41d655e6171bba1bc66d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ffb62f11f6446cebdba4ec34af2974285ef911511c41d655e6171bba1bc66d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d56d94e7c683bc21f5a09c2f4f6bb0ff0adb1bca8f573804ced54e734063bf74"
    sha256 cellar: :any_skip_relocation, ventura:       "d56d94e7c683bc21f5a09c2f4f6bb0ff0adb1bca8f573804ced54e734063bf74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ffb62f11f6446cebdba4ec34af2974285ef911511c41d655e6171bba1bc66d2"
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