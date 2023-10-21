class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://ghproxy.com/https://github.com/Raku/nqp/releases/download/2023.10/nqp-2023.10.tar.gz"
  sha256 "41051246635db1d4de08d373e2515ab76280f5e0c57d4a4fa2426545ac40956d"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "56f2469f72e76cf23c9a37b61d4df205afd8b4b722fc2ee1e59e16942ec3bef2"
    sha256 arm64_ventura:  "18c09f248513a160562063af3d391c9fa682a1fcd610f1917d8a1a43817075ab"
    sha256 arm64_monterey: "a11ac65662f5a28133b2da172710615452007d7e02d376ec1e14a576f71ac4ff"
    sha256 sonoma:         "93cc642098f2e61234397d7257bd08eb30062bcc7c3c7f5d3c798b79fe0ee8d6"
    sha256 ventura:        "ac4cb246ecddd4fff332d24783e32f85623707069872a96df059c5266c85c4ff"
    sha256 monterey:       "2eb524ad9fc39202135e9805d7d0b49a24aa9f8ae2a15d1cfec43e019c3e336e"
    sha256 x86_64_linux:   "a8233ef01f0335f8801e3d780cd68224f84d96993829759c12d39eda8c5603dc"
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