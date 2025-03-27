class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-8.18.0.tgz"
  sha256 "1072fb3173d8c0a2faed615001af59c61bc776bdd7dc6425fd99ffb33942f72f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2373b6b44e98644ee55d323e9ef02304c7bd1f08ed24a2a89b22de0b17af92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b2373b6b44e98644ee55d323e9ef02304c7bd1f08ed24a2a89b22de0b17af92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b2373b6b44e98644ee55d323e9ef02304c7bd1f08ed24a2a89b22de0b17af92"
    sha256 cellar: :any_skip_relocation, sonoma:        "3315f9dc72729c1eedf8b4154a939e6eca5eb511e3ba42173d20a856141d87ef"
    sha256 cellar: :any_skip_relocation, ventura:       "3315f9dc72729c1eedf8b4154a939e6eca5eb511e3ba42173d20a856141d87ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b2373b6b44e98644ee55d323e9ef02304c7bd1f08ed24a2a89b22de0b17af92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b2373b6b44e98644ee55d323e9ef02304c7bd1f08ed24a2a89b22de0b17af92"
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