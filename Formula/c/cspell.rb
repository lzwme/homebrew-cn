class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.2.0.tgz"
  sha256 "f9281d9cc44c111f851f795e977e9d54b224968b13226741a6dfa9081df7258a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "541639fc25b3eca3259675dd910d8773229625538c53f7f4ee9eac985e039c80"
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