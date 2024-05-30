class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.1.tar.bz2"
  sha256 "b1b44e9334df137bea5a73d9a84ebe71072bf622c63020a2a7a5536ecff1cd91"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "357e55befc5ef6c5f0e94723df47d21c8593ebef118487a9249150e30f289016"
    sha256 arm64_ventura:  "bbde30583264771f5570053ed601ea5f9357372dff962721879682c58db975f1"
    sha256 arm64_monterey: "5f00e3e541f5d4649a84c23f24735513b2bc390f16cb529bf0483a4781af8e5b"
    sha256 sonoma:         "52bb84e11022bf66b50b5143eaeb060279040f483610b92e5dd35626281582ad"
    sha256 ventura:        "98740040c41eff26e6daa35b046b27be8c659a267bc0905e558c2e6f2b797ac5"
    sha256 monterey:       "e3b938a5ab034f4b5ef8febc961a51394b8cbaa1947527c9fa88c199c7be634f"
    sha256 x86_64_linux:   "5a8ebda35239d1d35af00f3c9519d2cf7c3febe68c954d53966d878128feb0b3"
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