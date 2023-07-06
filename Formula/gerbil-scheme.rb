class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://ghproxy.com/https://github.com/vyzo/gerbil/archive/v0.17.tar.gz"
  sha256 "1e81265aba7e9022432649eb26b2e5c85a2bb631a315e4fa840b14cf336b2483"
  license any_of: ["LGPL-2.1-or-later", "Apache-2.0"]
  revision 2

  livecheck do
    url "https://github.com/vyzo/gerbil.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "7195fee8e11141c834407a5dce444f7bfe3519c6e9efc3b160638578aaa45cc2"
    sha256 arm64_monterey: "71498bf525476990e45974c5aee782147b8376363ee30f1646a5956ac40ec7f4"
    sha256 arm64_big_sur:  "eeeec31a2970ca32a9c78d9723bfdf716b5a0b42728dc3d6a1a768533fabe77f"
    sha256 ventura:        "fbe549f627d1357315932e801f9d5ea08cdf374d4693df91f5b49cbe65193b99"
    sha256 monterey:       "fb7f5e626e9344f0ff145ccca8800928caa66634d9c16222d0b7e788473b7e5e"
    sha256 big_sur:        "dc2cce1570095719ee451a8f0c11e7ebbd01e154f707b8ae30da9ec0cc7554ce"
    sha256 x86_64_linux:   "042ca2f6bfea2af7665cf66a6fa647bcc9a8f9bac047151be75f4bf04e52a754"
  end

  depends_on "gambit-scheme"
  depends_on "leveldb"
  depends_on "libyaml"
  depends_on "lmdb"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang do
    cause "gambit-scheme is built with GCC"
  end

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-gambit=#{Formula["gambit-scheme"].opt_prefix}",
                            "--enable-leveldb",
                            "--enable-libxml",
                            "--enable-libyaml",
                            "--enable-lmdb"
      system "./build.sh"
      system "./install"

      mv "#{share}/emacs/site-lisp/gerbil", "#{share}/emacs/site-lisp/gerbil-scheme"
    end
  end

  test do
    assert_equal "0123456789", shell_output("#{bin}/gxi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end