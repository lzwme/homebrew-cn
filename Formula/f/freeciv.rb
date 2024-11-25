class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https:freeciv.org"
  url "https:downloads.sourceforge.netprojectfreecivFreeciv%203.13.1.3freeciv-3.1.3.tar.xz"
  sha256 "741086fa94574374c7c27480f77ee68e5b538bfb2eff85004fa8c87b312c7f2f"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  bottle do
    sha256 arm64_sequoia: "6d1abb30bcc4fe1b8a6128b6c8a02558750b62a35d2ce17c928ecc02b2ab5346"
    sha256 arm64_sonoma:  "0e828f0b58d3837f9265aa8acf05ef832d928f302dc72c71393e70ce7f0a77a4"
    sha256 arm64_ventura: "ce9a0ad779b079b543ec361637ab54b86132e524a065619e2a68950ecd1afb4c"
    sha256 sonoma:        "445ba91f66a470a6d4c71c9e48e6784379d202ed6c4e56846560725a1bd197d6"
    sha256 ventura:       "ca8709bcc0ab6cbf1ae3a985f050fe37a5fa27489a05b78c41a08f843c2f0855"
    sha256 x86_64_linux:  "d9df907c1502e60e3dec825d65968a702618fa1bf300f43d554b13f9b4386b5f"
  end

  head do
    url "https:github.comfreecivfreeciv.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c@76"
  depends_on "pango"
  depends_on "readline"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["ac_cv_lib_lzma_lzma_code"] = "no"

    args = %W[
      --disable-gtktest
      --disable-sdl2framework
      --disable-sdl2test
      --disable-sdltest
      --disable-silent-rules
      --enable-client=gtk3.22
      --enable-fcdb=sqlite3
      --with-readline=#{Formula["readline"].opt_prefix}
      CFLAGS=-I#{Formula["gettext"].include}
      LDFLAGS=-L#{Formula["gettext"].lib}
    ]

    if build.head?
      inreplace ".autogen.sh", "libtoolize", "glibtoolize"
      system ".autogen.sh", *args, *std_configure_args
    else
      system ".configure", *args, *std_configure_args
    end

    system "make", "install"
  end

  test do
    system bin"freeciv-manual"
    %w[
      civ2civ31.html
      civ2civ32.html
      civ2civ33.html
      civ2civ34.html
      civ2civ35.html
      civ2civ36.html
      civ2civ37.html
      civ2civ38.html
    ].each do |file|
      assert_path_exists testpathfile
    end

    spawn bin"freeciv-server", "-l", testpath"test.log"
    sleep 5
    assert_path_exists testpath"test.log"
  end
end