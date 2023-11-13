class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.0.tar.bz2"
  sha256 "5941a4b5778929347482570dab05c9d780f3ab36e56f05b6301c39d911065e6f"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "c9c5cafd7997d252c7e56a68f78e0eb98a4f11b3539e2d93f9cea9b2b2ca2c67"
    sha256 arm64_ventura:  "47cae6cccef66d3542592cfb62a792158a7ca96cfcbc7c1fde1b6a5ef131d995"
    sha256 arm64_monterey: "fde58e9375557429edb8fbb411a785e9c8f864ac340cf38fdf861ea070765434"
    sha256 sonoma:         "a1e40b2348c123c0e7629048cf2c41e19b7fa92789a3b63d41f8360bc9bf40d6"
    sha256 ventura:        "630861827248dce85b2a821c68f749731dfc67b8d7491c8b95d92bc4526095ae"
    sha256 monterey:       "6379aa1d781159b6f659e050bca48231b3b5a922482da9bed2a78f3b3553858c"
    sha256 x86_64_linux:   "c61ebfa4b4238ef5af4f4ceed3c2c177b8f40a711dc990cba23095d0b28152bb"
  end

  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffms2"
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jpeg-turbo"
  depends_on "json-glib"
  depends_on "libconfig"
  depends_on "libheif"
  depends_on "libraw"
  depends_on "librsvg"
  depends_on "netpbm"
  depends_on "opencv"
  depends_on "openjpeg"
  depends_on "wcslib"

  uses_from_macos "perl" => :build

  on_macos do
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