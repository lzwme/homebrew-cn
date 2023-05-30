class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-381.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_381.orig.tar.gz"
  sha256 "924dd6ab1471d486d219aba4edb881a03dd4129fd55ee556390f7a1648f523bd"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4d59bb6afc6de10d121b33e76a2685e3abb11b579ce93d0cc1234e203c5ea3f3"
    sha256 arm64_monterey: "752ac6167d72b9a71ee942f0c1331f3e1e64c3e8bbd5f077926f4056c21cdc24"
    sha256 arm64_big_sur:  "e7be26e0573d8e615c84929a7017027f90622f09ad2c696d58b14a8a4525ca84"
    sha256 ventura:        "5dd6b2b30327dd1b919d48c7ce13516297a93d88e266fad8cfa7b5e229071771"
    sha256 monterey:       "3d027b3950e6b3e2fbd53da7c6882d7be9bd450ba1bb97601c63b8f7c926e4c4"
    sha256 big_sur:        "718f02f4f1699239d543009c87fca5ef19f2283c8b9d08206293fddbb6b1ae05"
    sha256 x86_64_linux:   "ed11b364bc8fd487d54c9eaf5e034dce0db5b80fa889698336e4f1c8d380a1d3"
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libice"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxext"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    %w[koi8rxterm resize uxterm xterm].each do |exe|
      assert_predicate bin/exe, :exist?
      assert_predicate bin/exe, :executable?
    end
  end
end