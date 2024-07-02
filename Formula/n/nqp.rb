class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https:github.comRakunqp"
  url "https:github.comRakunqpreleasesdownload2024.06nqp-2024.06.tar.gz"
  sha256 "0af0bd5a70aed446ffd246f2d354d88181e555aa6de826f1c40d76ab416bfa94"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sonoma:   "70ad99b892b63a5b9bf2777dbfe47cde7b1c5ba477e903e4e5241a584d7834a6"
    sha256 arm64_ventura:  "62c2d35f726cfcf95c4085ed66576ec4da08781871e710608881e39a7236e492"
    sha256 arm64_monterey: "04dc1591a42d72c8c3031d3271d2ef8e48161465ad1caefb47af39f3760f777c"
    sha256 sonoma:         "c8a7b51ebff216d71da7ccdacd13361b6c182416d771a2feafc7d2b3880b7ca5"
    sha256 ventura:        "71ab54cc76709b81bc9f132b1cb18d15b9e2197ddcac40e491dd0637bbf3db19"
    sha256 monterey:       "df95dd7504b2ae036c02fb184269b5f046257fea6bccf62d8ad5036116c05c41"
    sha256 x86_64_linux:   "a3cbaf4050fd3ce9331953cad2f2b4cff4d33b2dbb9f66c5d8017f3019c0b6be"
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