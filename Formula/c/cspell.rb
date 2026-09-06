class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-10.2.2.tgz"
  sha256 "9b6eecc54514eea5c5b0958abf63fd296efcce2747541c5216900a6b0ca33e3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22152a82b465ff4ac4f79f5a4ea1bfa1e625a77173663bbc03d8c3e0fc0cb6e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # Skip linking cspell-esm binary, which is identical to cspell.
    bin.install_symlink libexec/"bin/cspell"

    # Replace code comment to build :all bottle
    node_modules = libexec/"lib/node_modules/cspell/node_modules"
    inreplace node_modules/"global-directory/index.js", "/opt/homebrew", ""
  end

  test do
    (testpath/"test.rb").write("misspell_worrd = 1")
    output = shell_output("#{bin}/cspell test.rb", 1)
    assert_match "test.rb:1:10 - Unknown word (worrd)", output
  end
end