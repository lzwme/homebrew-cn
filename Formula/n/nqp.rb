class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://ghproxy.com/https://github.com/Raku/nqp/releases/download/2023.11/nqp-2023.11.tar.gz"
  sha256 "e7176b1a6fbaa98c132e385f325c6211ff9f93c0a3f0a23ceb6ffe823747b297"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "33b596bf3183107bb94165340232de4832e3ad2d9e0ede028dfa86eecf941708"
    sha256 arm64_ventura:  "2474fa1e5309fab900eb09448982b733d825bab8ab0a3518b16841b67ef21f82"
    sha256 arm64_monterey: "caeddc8164bacc1e2751c79d7b38b8a0d1af48e63206f9fc0aca57d6a9dfa851"
    sha256 sonoma:         "4e2d6c16b4f0b92fc04dceaf4feb6d24d85b14d9a5523c6fb315be626dd86821"
    sha256 ventura:        "4c353aaeaccc455ccb977be130afc16827036d65ec9f29a21231242700de987d"
    sha256 monterey:       "3f723b6b01e2dde4845ff856882cdade0e7e4d4c3c672dfec4ca91e9125a1b0e"
    sha256 x86_64_linux:   "c30cded4cbdaf512863a1a2cf0c01cb7a7631144a6b517db1eafee29ed23d864"
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
    inreplace "tools/build/gen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}/nqp/lib/MAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end