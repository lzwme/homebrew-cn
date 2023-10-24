class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://ghproxy.com/https://github.com/vyzo/gerbil/archive/refs/tags/v0.17.tar.gz"
  sha256 "1e81265aba7e9022432649eb26b2e5c85a2bb631a315e4fa840b14cf336b2483"
  license any_of: ["LGPL-2.1-or-later", "Apache-2.0"]
  revision 3

  livecheck do
    url "https://github.com/vyzo/gerbil.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "5568e6b56fed556b8c0145de4d54d6dc256c0d75af3e43a88a34c4f3b4922a0f"
    sha256 arm64_monterey: "eea0039afa114fcf1329ca303a4b1829141a8b94d95520409109b362ffe459f6"
    sha256 arm64_big_sur:  "a95805093e7668f057a9bead359aed795887a461c6399fe7da08a2a365d0a176"
    sha256 ventura:        "29e03e2cce80923ebace68b450dd7ac32c0fb8e9d5108ad1734c20b133e70306"
    sha256 monterey:       "f3048903ad1fd2bd101cabb22d7587229d8e92712f6fb1724d5683664ad1e80b"
    sha256 big_sur:        "f6e7338913c1e66538c1af4d177c63869dd33554f0aa5d14be7143eefa724330"
    sha256 x86_64_linux:   "878b862448fe401b00980688c6c880ef4344cc88272bb29ed6c1ddb1ce14460f"
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