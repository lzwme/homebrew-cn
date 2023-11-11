class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.9/freeciv-3.0.9.tar.xz"
  sha256 "16c46a9c378b4a511c1e3d3a7c435a78230a432d8b852202aaf5d5d584962742"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sonoma:   "240a68815576916c7a2bdb1bb3fb845217fc4359c5f279c7bb00b95764cfad5a"
    sha256 arm64_ventura:  "612a97af225705592ea9f707a7f74c4bf18a86f09f322efe699c886ca5d71d72"
    sha256 arm64_monterey: "cb121743441d8e6315466de0f17a9857079b8e9598441c7bb61dc519b353653c"
    sha256 sonoma:         "596f187286631e7949e3026b94427d07ef4208d6c63b19d3ca11434f895dec4b"
    sha256 ventura:        "5fbd4a1a450064f1f0e5f80dd6119e6d56d88fb2fb6a4dff6a46bf3dd0d1fb79"
    sha256 monterey:       "7bed78286936135408eeb5350781418a73490d1bc1f8b4d3df62066fe0458e8b"
    sha256 x86_64_linux:   "f663487d18ccc02a3e9506f41d09ec7aabecd7c5aba302d252f2718fed708943"
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
  depends_on "atk"
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