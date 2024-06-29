class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20240625.tar.gz"
  sha256 "b5c06c2f2896b4e4d9b4444b155dc85b15c90e40253ecc3889a92ca457af7164"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a59a6f33dafe654520f4204111e783dba5688bdead1e3c0bd0a15d15eef4dde5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "592e281e3de1abc33e0df56cbb059cfccab094f6bc519fadd0cb416ade847cbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6405f4de05ccac3dbc09ddb955f8f4c75bae235961e73afe9b9684b678ce0187"
    sha256                               sonoma:         "1faf28388ae722e83fb435903f0053533547e98d36487dfa8a0ab453849fd789"
    sha256                               ventura:        "05ea44d1beba7b6bd68abee506cf6f49e97b1cd1214ca9d89508c7b4024ca938"
    sha256                               monterey:       "1363441562431b3f8e7ce7030dd789212505b6cc07e5e14730d6ac2a724c1540"
    sha256                               x86_64_linux:   "74d247c0b8658cfb12892d507c7601ffe3aadd7f6bf8a2c20b502c76e68988bb"
  end

  uses_from_macos "bc" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end