class Siril < Formula
  desc "Astronomical image processing tool"
  homepage "https://www.siril.org"
  license "GPL-3.0-or-later"
  revision 2
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
    sha256 arm64_sonoma:   "33922c686ad84821d5bc1a04a5c540725f0dfc77d0a4cdce27beb961c5949509"
    sha256 arm64_ventura:  "8a4a6d473b8b693e79f706df3f9e36dd98a775c98f32d6e42fb87b10de2c44a9"
    sha256 arm64_monterey: "c3ae5b816fe7a495308f6757a0efd7cea863d00adc4183e34e21b014529315e2"
    sha256 sonoma:         "db52eb9a39ea334070995d0b21c1c36d8e2010f664988ae766909e0470c5e4ff"
    sha256 ventura:        "7c37c42106b9914cebe8b2b5587074ff5b4b0ff5c51bebaa20b4258e02d40a94"
    sha256 monterey:       "7e3ef4144957b19c986e3aa1c3192e45936d8b14b0cb446cfa9218e5a2b485a2"
    sha256 x86_64_linux:   "12a108862be66ec25ec158ad9831619ee70fd3809af5860d8a23ad4066b54653"
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