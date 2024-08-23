class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.3.tar.bz2"
  sha256 "8ac660542d2bec5d608eaf9bf25a25e6ba574b58b5410bdb6ad401e1f86fa756"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "1b438076e078b90b8aa351f5e470917152d179f1f5169edc53ae2fbcf82b1eb6"
    sha256 arm64_ventura:  "53991a72d61e988dc39666384578ce9ef0abc2a36e9404d62e0c58c103a04422"
    sha256 arm64_monterey: "04e62c548fb17bb2efef6cd9816f415fc0eac048ef86712ba54e1236dec5590e"
    sha256 sonoma:         "3bc7cb77db14ac2ab537206eace33c7f11c26e975293abb8208d6160463e2e6c"
    sha256 ventura:        "22b510a8ae114cac65d26d5f14d69aee713fb6586b7aa1fd79b1ef0f6b61e448"
    sha256 monterey:       "a28a278462d36c513a895630a49393984291f47bd2424e9b159e07a2d1f5529f"
    sha256 x86_64_linux:   "de834dbcab8bc30d5beecf176ef0ead7535d643f8620a258d839b2753656540f"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffmpeg"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"
  depends_on "pango"
  depends_on "wcslib"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext"
    depends_on "gtk-mac-integration"
    depends_on "libomp"
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    args = %w[
      --force-fallback-for=kplot
    ]

    system "meson", "setup", "_build", *args, *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    system "meson", "install", "-C", "_build"
  end

  test do
    system bin/"siril", "-v"
  end
end