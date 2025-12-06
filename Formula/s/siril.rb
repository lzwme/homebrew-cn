class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.0.tar.bz2"
  sha256 "439def7c40ad783afb82e87f3c656d85b449c701f67ab0a9b97ca372ea2d73c9"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a586c6d301c2872fe79ef4f0c93fa7dd2c0f83c471cc65131ddb5b6c117470a3"
    sha256 arm64_sequoia: "58c649ed00f6bab3b3c2b5ca9c60ecfd77ad6ad8df821f27a2a3d660d32cad24"
    sha256 arm64_sonoma:  "00bdd82a57abc899d296315e4cfcd6f812528d3cda7481408be53a7e2f0855d8"
    sha256 sonoma:        "7da2c7b65b92601989716f10591cae1946d6533723ebbbe82edc5605fa45b1e4"
    sha256 arm64_linux:   "8b4c6657321e6c9e174ceabcb7c40a0c960360d35dc587fbba0a463760788b19"
    sha256 x86_64_linux:  "0e708367951e48233c1f79bbba574648a4bde8e3898d655ff496b6ad556437e0"
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