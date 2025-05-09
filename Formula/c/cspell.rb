class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.0.1.tgz"
  sha256 "5d68a8ad5228766aafb0e88ac2d07942dad506d652b2620805a501202509f37c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdeb751f85e1838bf3743169b80bf1604da6acda4756531f75397d59889db24e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdeb751f85e1838bf3743169b80bf1604da6acda4756531f75397d59889db24e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdeb751f85e1838bf3743169b80bf1604da6acda4756531f75397d59889db24e"
    sha256 cellar: :any_skip_relocation, sonoma:        "23bc69b7b434f59f5d6aa3873c8a08b620d65a20287069ea14899505601608ae"
    sha256 cellar: :any_skip_relocation, ventura:       "23bc69b7b434f59f5d6aa3873c8a08b620d65a20287069ea14899505601608ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdeb751f85e1838bf3743169b80bf1604da6acda4756531f75397d59889db24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdeb751f85e1838bf3743169b80bf1604da6acda4756531f75397d59889db24e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"
  end

  test do
    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end