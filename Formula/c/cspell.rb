class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-8.19.3.tgz"
  sha256 "04cdc9ed2cebeac0987fb5c4840cf7b5905163b07f67b02bdc68412699e884fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d881946a73da528c08aeca48236d5484272aac5151d8625a61a05cd5c53318e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d881946a73da528c08aeca48236d5484272aac5151d8625a61a05cd5c53318e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d881946a73da528c08aeca48236d5484272aac5151d8625a61a05cd5c53318e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "65eeee1b22b8cdf3a807d76e39e2b8e5f20f298fe4399bb3865ba5997a72bf9e"
    sha256 cellar: :any_skip_relocation, ventura:       "65eeee1b22b8cdf3a807d76e39e2b8e5f20f298fe4399bb3865ba5997a72bf9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d881946a73da528c08aeca48236d5484272aac5151d8625a61a05cd5c53318e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d881946a73da528c08aeca48236d5484272aac5151d8625a61a05cd5c53318e2"
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