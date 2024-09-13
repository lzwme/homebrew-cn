class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https:github.comRakunqp"
  url "https:github.comRakunqpreleasesdownload2024.08nqp-2024.08.tar.gz"
  sha256 "6b9835ee5c0aa9e561cc7cecc846fe496ffe432567407bf0c3c14c3f3a2711a0"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia:  "8600a0ca262820dd5bd3526728489b4ddbe49a199ac4d9d03273b2d53b7a4996"
    sha256 arm64_sonoma:   "5e92bdb5e4a023acb1e303081aa68bba12f85470195aa63557f5953f54bf3710"
    sha256 arm64_ventura:  "0561e42cec3275a3bcaaf9f9b891b5a36541a9e0d7e26f96547ae8cb22146bed"
    sha256 arm64_monterey: "fd66b2ba5905e9a9885e881fc76428296ebac24a532c21cf73647c85046a3ae6"
    sha256 sonoma:         "83a7bd5c15cdba6540120fc38d73edbca9de718b316df172547cde52bba4db6f"
    sha256 ventura:        "fcb0ecf45b76dd23fc12e8ddd383ed70e9d11704dc125c1cadd2ea7cb8b0159e"
    sha256 monterey:       "56bc63e71970219ca6d03320f935b94c2303f9b5ea8ecd76c373d2adec6f04c5"
    sha256 x86_64_linux:   "18b90e07150f43141f6d6206bc19711f006b4bd32da0a4adb4f9e1e6b190a8ee"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "toolsbuildgen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}nqplibMAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end