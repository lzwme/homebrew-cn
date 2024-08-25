class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https:fennel-lang.org"
  url "https:github.combakpakinFennelarchiverefstags1.5.0.tar.gz"
  sha256 "f5ca4a688e9b97d0783b10a834e3563e3d881669c29f89135b5abffce631527a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b8222c2ccc6966f22ab3a710201fefef9b3a445b076673ad3ac81e65bb572ba9"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fennel"

    lua = Formula["lua"]
    (share"lua"lua.version.major_minor).install "fennel.lua"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}fennel -e '(print \"hello, world!\")'")
  end
end