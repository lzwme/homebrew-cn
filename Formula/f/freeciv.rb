class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.9/freeciv-3.0.9.tar.xz"
  sha256 "16c46a9c378b4a511c1e3d3a7c435a78230a432d8b852202aaf5d5d584962742"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sonoma:   "6fd841695c7ef4e7bc165f703398c2deda2fd84a3cbd64623105c7b4a0c5f70f"
    sha256 arm64_ventura:  "f92f4c645818708fd11dff733c18dba884ad8538264f7a79cb372e02f68e942b"
    sha256 arm64_monterey: "3fcc8da63144aeca1c76b067362f27731a645b8d58c8915f8fad5314287f7583"
    sha256 sonoma:         "5ebb747350afb01f87bafdbcc56b6692a1b845321667cb9cdab7a4757c241460"
    sha256 ventura:        "7d46ccfd66b8c1ae7df3e3fae33e7cbf21d10b54056568e1801decef03fa2061"
    sha256 monterey:       "57d906f0bb2a748be9d36c2f122ba103fd20a9966971ba03856a972134879f39"
    sha256 x86_64_linux:   "c19e9cde02717722e74058247adae7ef8df5f893b5f828c18cead0d2ced6f595"
  end

  head do
    url "https://github.com/freeciv/freeciv.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "pango"
  depends_on "readline"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["ac_cv_lib_lzma_lzma_code"] = "no"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-gtktest
      --disable-silent-rules
      --disable-sdltest
      --disable-sdl2test
      --disable-sdl2framework
      --enable-client=gtk3.22
      --enable-fcdb=sqlite3
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      CFLAGS=-I#{Formula["gettext"].include}
      LDFLAGS=-L#{Formula["gettext"].lib}
    ]

    if build.head?
      inreplace "./autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"freeciv-manual"
    assert_predicate testpath/"civ2civ36.mediawiki", :exist?

    fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    assert_predicate testpath/"test.log", :exist?
  end
end