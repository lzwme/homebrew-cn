class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.2.1.tar.bz2"
  sha256 "b1b44e9334df137bea5a73d9a84ebe71072bf622c63020a2a7a5536ecff1cd91"
  license "GPL-3.0-or-later"
  revision 3
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "bf65d9b5fa807085553dd9afb5bdf2d6a8056e61a5817d68b347edc61019ff0d"
    sha256 arm64_ventura:  "8529e57dfc1c686f550f68f26db5fcbc71f5051e34eef8eb55684835eaf99e9e"
    sha256 arm64_monterey: "16f0ef1e7e3f62e84ae24ff38175b2c6c2c9cd3143937b7ab28e7c5eeb82647f"
    sha256 sonoma:         "c194acfc6515141c6437bea830dd711e312aa02b8e868d62a41789cf63862851"
    sha256 ventura:        "a6128cf9fc3988572e6f60009209c1dd67567c06772f6dd22ff2f362df8cd475"
    sha256 monterey:       "9a731dbe543a2c5f2e543fc2f58fde4ba9cc16da228335c03d5deac5f66fd8ed"
    sha256 x86_64_linux:   "aee10bedb8f58c7c5d729fbdd403f3dfdb02db6ed193e88a6c3110b8057f2e2b"
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