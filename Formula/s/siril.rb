class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.3.tar.bz2"
  sha256 "8ac660542d2bec5d608eaf9bf25a25e6ba574b58b5410bdb6ad401e1f86fa756"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "b0ecf526c4bd4fc258a03f7316cc896b0ea9996bdced559a5dfbdf1bf8822723"
    sha256 arm64_ventura:  "840090f76fcf6e786ad3ab2356a4616f52fb6f1a7b63cd9a6f1a697e5493aacb"
    sha256 arm64_monterey: "581a64e9176fca55ce5fc15dddb42db5c100caa5388337cc3f5dcd87404d2355"
    sha256 sonoma:         "59890c8760f2905f785ce8000977a559c41a88593a97e2afe272064b8b8e8631"
    sha256 ventura:        "81fc996bb795d254d6c5afa53f632690fb5b9fc7700edbf3d8078ef07d8b5c5b"
    sha256 monterey:       "480c579065368a1cdb464e1fa48cce7fc3c217215236c992e8a8669873c2f507"
    sha256 x86_64_linux:   "8db594c978770f948f34651e1e7d14ec105c364bbc331ceef41d7e81a4405d76"
  end

  depends_on "cmake" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "cfitsio"
  depends_on "exiv2"
  depends_on "ffmpeg@6"
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