class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.2.2.tgz"
  sha256 "efe6bd85b62f77142780ff2ec0604213128cdec2a243172b606d849df1a07786"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2442352d735807b29b17fa9755f23446f797a45be8ca58cf01165642c745790"
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