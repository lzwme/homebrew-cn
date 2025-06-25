class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.1.2.tgz"
  sha256 "170438975b31b4ee7637555cb2a5c247df035d77923ab23554f7cf3f11921b8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b489a02001fe7075c34a62d27d209b890b5c8911bffee8f1246d3547411a04cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b489a02001fe7075c34a62d27d209b890b5c8911bffee8f1246d3547411a04cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b489a02001fe7075c34a62d27d209b890b5c8911bffee8f1246d3547411a04cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7924a0b78f5f8fcf6148d101312d63356dd14537e2c1191df0bdbbc5a80c0618"
    sha256 cellar: :any_skip_relocation, ventura:       "7924a0b78f5f8fcf6148d101312d63356dd14537e2c1191df0bdbbc5a80c0618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b489a02001fe7075c34a62d27d209b890b5c8911bffee8f1246d3547411a04cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b489a02001fe7075c34a62d27d209b890b5c8911bffee8f1246d3547411a04cd"
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