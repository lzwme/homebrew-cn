class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.2/3.2.3/freeciv-3.2.3.tar.xz"
  sha256 "989d6d58bd4cd97a4899e7e25afdee6c35fd03f87a379428a6e196d600d8d307"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_tahoe:   "3cbe6eaa8f40c6e4644eb1bb7d5af97f3425fd1f3378ff7d133c6673780c6e18"
    sha256 arm64_sequoia: "fd63a5fddf2683709aa2a2303827e79bdc6950744c854fa4d2159cd90bc19815"
    sha256 arm64_sonoma:  "e447325fce7a9bab451204a62204b8e783417b66ceeac2f3ad3a272789af1974"
    sha256 sonoma:        "f34c1a025f36b55ac16f1790b6f9e282c299a61bf4fc1f19cad9d55f16a8852f"
    sha256 arm64_linux:   "f926a11483072bd11599bfe1fead4d63a6a42955b217139f5d48e31b431ac468"
    sha256 x86_64_linux:  "9a114b68ec923737b713e617b4cc19c5ad25113ca27ccda5beb382dae48a1cae"
  end

  head do
    url "https://github.com/freeciv/freeciv.git", branch: "main"

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
  depends_on "icu4c@78"
  depends_on "pango"
  depends_on "readline"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      inreplace "./autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh", *args, *std_configure_args
    else
      system "./configure", *args, *std_configure_args
    end

    system "make", "install"
  end

  test do
    system bin/"freeciv-manual"
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
      assert_path_exists testpath/file
    end

    spawn bin/"freeciv-server", "-l", testpath/"test.log"
    sleep 5
    assert_path_exists testpath/"test.log"
  end
end