class Cspell < Formula
  desc "Spell checker for code"
  homepage "https://cspell.org"
  url "https://registry.npmjs.org/cspell/-/cspell-8.19.4.tgz"
  sha256 "29106e104df41b05b02ba453ad4a7346355f96743e847d968264229a724539f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1297e2bac3e41600ab1dd34b0e64b6506ca1e1dc5971d359edfcd9177e66ceec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1297e2bac3e41600ab1dd34b0e64b6506ca1e1dc5971d359edfcd9177e66ceec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1297e2bac3e41600ab1dd34b0e64b6506ca1e1dc5971d359edfcd9177e66ceec"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6b81265aab0eaab51dec8ddd3a643a59484e989023cda3eb763419ea25b66cb"
    sha256 cellar: :any_skip_relocation, ventura:       "b6b81265aab0eaab51dec8ddd3a643a59484e989023cda3eb763419ea25b66cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1297e2bac3e41600ab1dd34b0e64b6506ca1e1dc5971d359edfcd9177e66ceec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1297e2bac3e41600ab1dd34b0e64b6506ca1e1dc5971d359edfcd9177e66ceec"
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