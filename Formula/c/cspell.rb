class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-8.19.0.tgz"
  sha256 "abf8fdfe4d833407ec9beb836d525f55f3db931bc5d3933d149e63e5baf1c0ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76a066c45e2f6ea65cd1cb2ddb20b40faf340c97fde584464804ca97dfe11bc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76a066c45e2f6ea65cd1cb2ddb20b40faf340c97fde584464804ca97dfe11bc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76a066c45e2f6ea65cd1cb2ddb20b40faf340c97fde584464804ca97dfe11bc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "269d0b81c11872f7b07ff362bceb20d0b39302454a8c6f4922dc14e4ac339886"
    sha256 cellar: :any_skip_relocation, ventura:       "269d0b81c11872f7b07ff362bceb20d0b39302454a8c6f4922dc14e4ac339886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76a066c45e2f6ea65cd1cb2ddb20b40faf340c97fde584464804ca97dfe11bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a066c45e2f6ea65cd1cb2ddb20b40faf340c97fde584464804ca97dfe11bc8"
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