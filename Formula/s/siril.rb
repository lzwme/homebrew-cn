class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.0.tar.bz2"
  sha256 "439def7c40ad783afb82e87f3c656d85b449c701f67ab0a9b97ca372ea2d73c9"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "dcd225cc1c297680976764253c024f7ea751cccfc8a8f71b9d120c3a24aa6912"
    sha256 arm64_sequoia: "1876bfe5030959ba435047adb18df02ee32b6917a70394fd847e58bafbd55945"
    sha256 arm64_sonoma:  "2cb8fd3ee5e2614c4ea2504da138b7b7f2886587d9c0e89baedfa913533fc81e"
    sha256 sonoma:        "e24e03cc2780540d085c364681c38afbaceb286cc182e16825f995861d3fa24d"
    sha256 arm64_linux:   "76028b1737aa66640f2dc471f53d5bb2167973dbd439952778ba7f7644182724"
    sha256 x86_64_linux:  "bc8c6da5940b0d94fbdf681238aea3c118191275b1db99da3b094a171a9968fd"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

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
  depends_on "gtksourceview4"
  depends_on "healpix"
  depends_on "jpeg-turbo"
  depends_on "jpeg-xl"
  depends_on "json-glib"
  depends_on "libgit2"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "pango"
  depends_on "wcslib"
  depends_on "yyjson"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "libomp"
  end

  def install
    args = %w[
      --force-fallback-for=kplot
      -DlibXISF=false
      -Dcriterion=false
    ]

    system "meson", "setup", "_build", *args, *std_meson_args
    system "meson", "compile", "-C", "_build", "--verbose"
    system "meson", "install", "-C", "_build"
  end

  test do
    system bin/"siril", "-v"
  end
end