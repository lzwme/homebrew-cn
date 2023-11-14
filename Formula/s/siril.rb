class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  stable do
    url "https://free-astro.org/download/siril-1.2.0.tar.bz2"
    sha256 "5941a4b5778929347482570dab05c9d780f3ab36e56f05b6301c39d911065e6f"

    # TODO: Remove this patch on the next version after 1.2.0.
    patch do
      url "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-astronomy/siril/files/siril-1.2-exiv2-0.28.patch?id=002882203ad6a2b08ce035a18b95844a9f4b85d0"
      sha256 "023a1a084f3005ed90649e71c70d59335d2efcd06875433f2cc2841f9d357eba"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "167fb3ed38eb1799bfb99899c9f3979c2dd3dccae9e95e3fdbb822d1e7042a64"
    sha256 arm64_ventura:  "3889fd0c75874e6b736de82471f837fe1685d0821b14547e50d80f921b67cf78"
    sha256 arm64_monterey: "f79fd417b791382a23c6e8afac09c8e425a63e9f920b87758bdb535840f5e6d2"
    sha256 sonoma:         "b6b66d66d499aff064b0e7a432170905b450583629b87beb4944136393910ceb"
    sha256 ventura:        "0e3a6a09d544830dbb144c0c192e467f3eb2471ea6014a2c21166f69d4990487"
    sha256 monterey:       "d158ead4b49dc102fb3083396dceee31cfe8e7d09e9cfe362e12f3835f39da05"
    sha256 x86_64_linux:   "266ac82bad2e8b77368baf8d73a900e6ac1cfa2a4f92fcc360fd8e5fdc001e39"
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