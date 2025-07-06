class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.1.3.tgz"
  sha256 "0350b43c16bffb5f03a822d234fbfb478b75bdb556aeeb175e5374a5496033c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf777d7bb2fa30420848bc0d2718130235b8fa9833460164b61b519b4c2f610e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf777d7bb2fa30420848bc0d2718130235b8fa9833460164b61b519b4c2f610e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf777d7bb2fa30420848bc0d2718130235b8fa9833460164b61b519b4c2f610e"
    sha256 cellar: :any_skip_relocation, sonoma:        "72731b529a8340692dcc025d2fea0daa01c7792df38f5bd7120b765695ae2014"
    sha256 cellar: :any_skip_relocation, ventura:       "72731b529a8340692dcc025d2fea0daa01c7792df38f5bd7120b765695ae2014"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf777d7bb2fa30420848bc0d2718130235b8fa9833460164b61b519b4c2f610e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf777d7bb2fa30420848bc0d2718130235b8fa9833460164b61b519b4c2f610e"
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