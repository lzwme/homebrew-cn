class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.6.tar.bz2"
  sha256 "312f82e78599f796d163a6d1c90589df1ed920b9ff2bb7ab5b808e43872817fa"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:  "5560e2d8d33b65ab4d6ba303235bd4d81e325e00a51e8b59415ee945c7cbb25e"
    sha256 arm64_ventura: "7a1efdb4b059a74f290c608069bf50c4ce67d10a215dfd5b4d0f2f062440fb01"
    sha256 sonoma:        "e57de7b3622cb2d2c0de3d867ffccdad8d0b21db5fefd53ba0948bbfd87a8b0b"
    sha256 ventura:       "0d00881d5bdbb82f7267ab520e3732e120067dea8c6ff19c21080f77b9897c28"
    sha256 x86_64_linux:  "698f0f0ac056a88d843228bcbb5c76bb77db203be016523d72d744b8806f2e64"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffmpeg@7"
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