require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.4.0.tgz"
  sha256 "542cf4ce5680b4db95341bf9a5466154278ce607f2d7d6e836a8ff6faf459a75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "47cc96904a852a1133fd50f50ab50b56649eeb21a3889d5998b5508da7e83f23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47cc96904a852a1133fd50f50ab50b56649eeb21a3889d5998b5508da7e83f23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47cc96904a852a1133fd50f50ab50b56649eeb21a3889d5998b5508da7e83f23"
    sha256 cellar: :any_skip_relocation, sonoma:         "41fa97dbb479827837397da65f404dc0e0e17e1f15aafa81cfbd1f6f6c5f8ee2"
    sha256 cellar: :any_skip_relocation, ventura:        "41fa97dbb479827837397da65f404dc0e0e17e1f15aafa81cfbd1f6f6c5f8ee2"
    sha256 cellar: :any_skip_relocation, monterey:       "41fa97dbb479827837397da65f404dc0e0e17e1f15aafa81cfbd1f6f6c5f8ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47cc96904a852a1133fd50f50ab50b56649eeb21a3889d5998b5508da7e83f23"
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