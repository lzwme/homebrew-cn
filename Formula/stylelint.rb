require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-15.10.1.tgz"
  sha256 "00e9ed8a1618517979432508901106d3c78f358e5f016807f85a5dba8c46ba7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17ac14223f78887d1794158f564a8e90b7cd1dac40c1bdadbc3bcb94c83a78a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17ac14223f78887d1794158f564a8e90b7cd1dac40c1bdadbc3bcb94c83a78a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17ac14223f78887d1794158f564a8e90b7cd1dac40c1bdadbc3bcb94c83a78a0"
    sha256 cellar: :any_skip_relocation, ventura:        "dadef8abb2fdbd1d41874d0e1d36f600df132502dc154f6bc136d23c4ed33057"
    sha256 cellar: :any_skip_relocation, monterey:       "dadef8abb2fdbd1d41874d0e1d36f600df132502dc154f6bc136d23c4ed33057"
    sha256 cellar: :any_skip_relocation, big_sur:        "dadef8abb2fdbd1d41874d0e1d36f600df132502dc154f6bc136d23c4ed33057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ac14223f78887d1794158f564a8e90b7cd1dac40c1bdadbc3bcb94c83a78a0"
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