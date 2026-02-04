class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-9.6.3.tgz"
  sha256 "248635514fe3107d32a7fd667575444db4543873b6e7b5cae7d917fdb5e1ec63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "559828cc22773c5b82631f548c995e7afe9d0abe5789f1781d3b93db6a28d5e8"
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