class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  url "https://free-astro.org/download/siril-1.4.1.tar.bz2"
  sha256 "5547567e4f72318d650f21234cfe109b578d6d0cdea23799dbe8a91f707a5cc9"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/free-astro/siril.git", branch: "master"

  livecheck do
    url "https://siril.org/download/"
    regex(/href=.*?siril[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a7a4001589c8b94c754d9bec02f153f9bef4171fa487de8d76286a022b960d30"
    sha256 arm64_sequoia: "45f37f9788dee28a3e1ad71d0dacd1ab33af45db93c38a578311c6026770cd4e"
    sha256 arm64_sonoma:  "a7234f7e17ced0e00e120164cc90540cd12ae7fa3b78cce1b80c760a0f1c46c1"
    sha256 sonoma:        "c8b717ced036e5d48227aef3a27b41d19ca9338f95d780e032142cbdb0f85842"
    sha256 arm64_linux:   "5db6e6dc700bf90598e95f1a5202f12f3b7bb13f0df192f2edaec003b8f00522"
    sha256 x86_64_linux:  "10179f8f5dab02e334782ec866f737ea3194ad72f96bb8e4c66330df5482d70d"
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