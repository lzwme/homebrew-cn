class GerbilScheme < Formula
  desc "Opinionated dialect of Scheme designed for Systems Programming"
  homepage "https://cons.io"
  url "https://ghproxy.com/https://github.com/vyzo/gerbil/archive/v0.17.tar.gz"
  sha256 "1e81265aba7e9022432649eb26b2e5c85a2bb631a315e4fa840b14cf336b2483"
  license any_of: ["LGPL-2.1-or-later", "Apache-2.0"]
  revision 1

  livecheck do
    url "https://github.com/vyzo/gerbil.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "fc2a781bd879e122d93d72d98c583acf7a34b0657f01c74d8e48f43ceee1f2d9"
    sha256 arm64_monterey: "159b9c77623807839b0b91d6cee08fa36123bb3fa02de52eefbf7efedbd9c306"
    sha256 arm64_big_sur:  "cfa4b888ccece5b4947981464df7f809007549becd53578bedb3c83344694c06"
    sha256 ventura:        "6675e742ccab7a8f95815e1e5a660dcb44855d7135d270732c18e99507057db1"
    sha256 monterey:       "0a3aa5f893c5650ecfa7a79c56ccb12f5f88c8f405e19b4492d91a9b2fe1c572"
    sha256 big_sur:        "dbcbb851c325735d541c1ca0dcc835f813bc73b5075cd27b6782e07298b88c3d"
    sha256 x86_64_linux:   "40ec2d12c4e67c82c8ff1aa7fe1113b4af01ccddf8e6f512f01770fcc5c7aeb3"
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