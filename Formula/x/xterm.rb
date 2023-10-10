class Xterm < Formula
  desc "Terminal emulator for the X Window System"
  homepage "https://invisible-island.net/xterm/"
  url "https://invisible-mirror.net/archives/xterm/xterm-386.tgz"
  mirror "https://deb.debian.org/debian/pool/main/x/xterm/xterm_386.orig.tar.gz"
  sha256 "cbabf953c79a491949f7a840dc3a1d187cb0faa47cb5ce786c1afe0d440fc7c4"
  license "X11"

  livecheck do
    url "https://invisible-mirror.net/archives/xterm/"
    regex(/href=.*?xterm[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "455fb22e784461f4792224e999ebcf0150e8a89aa8235499b3f8709c8e547039"
    sha256 arm64_ventura:  "e1de74d679e372c394485d6bc88adb6f68743cb9b937eb76c9fe6f8037904ad8"
    sha256 arm64_monterey: "79e1404ef47b6409c1892b7a114b8cfc6d23cd26bd0d53770f81c607e6a6c503"
    sha256 sonoma:         "5147166cdbc1ef1954e4697e89b9e9bae92f042ca1265b1e42f266283dd7753c"
    sha256 ventura:        "a424b28dfcafcb0ea0eb18056945a5d8c611c562a0e132434db18ec79ecda23d"
    sha256 monterey:       "9a2b113527c050d2d938d240d61c3df0a60e7fd3371ebb6c4a1b6f7c14bc7559"
    sha256 x86_64_linux:   "f075aca29e9de8f51e9ba171b31a08cf866516333bb1ddb5b533de51d1637c75"
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