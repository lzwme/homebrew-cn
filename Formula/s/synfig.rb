class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://www.synfig.org/"
  # TODO: Update livecheck to track only stable releases when 1.6.x is available.
  url "https://ghfast.top/https://github.com/synfig/synfig/releases/download/v1.5.3/synfig-1.5.3.tar.gz"
  sha256 "913c9cee6e5ad8fd6db3b3607c5b5ae0312f9ee6720c60619e3a97da98501ea8"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/synfig/synfig.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_sonoma:  "874944b05891c59695ff2db7d9ccece4297c3eadc5d3700499699a9be14977e1"
    sha256                               arm64_ventura: "950daa1ac3dfd7c6ad66071fe60807beb2d508cc94872ad2c9a5494d278dfef8"
    sha256                               sonoma:        "51c1bfcd664a5163081b7cd1b198a30a3f93661bfb0180c7e9f6c0165090cfbd"
    sha256                               ventura:       "1ca46bdf9ced9af39f3c679252ae5bedf802fb6814ef3f6d7507a20be5c05336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "070671c26baba156cf1fd71ad07873761a7d5e4b230af6dc6bdeb9aeb19ea7c2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "etl"
  depends_on "ffmpeg@7"
  depends_on "fftw"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "gettext"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "harfbuzz"
  depends_on "imagemagick"
  depends_on "imath"
  depends_on "libmng"
  depends_on "libpng"
  depends_on "libsigc++@2"
  depends_on "libtool"
  depends_on "libxml++"
  depends_on "mlt"
  depends_on "openexr"
  depends_on "pango"

  uses_from_macos "perl" => :build
  uses_from_macos "zlib"

  on_macos do
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.cxx11

    # missing install-sh in the tarball, and re-generate configure script
    # upstream bug report, https://github.com/synfig/synfig/issues/3398
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-silent-rules",
                          "--without-jpeg",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stddef.h>
      #include <synfig/version.h>
      int main(int argc, char *argv[])
      {
        const char *version = synfig::get_version();
        return 0;
      }
    CPP

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["ffmpeg@7"].opt_lib/"pkgconfig"
    pkgconf_flags = shell_output("pkgconf --cflags --libs libavcodec synfig").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *pkgconf_flags
    system "./test"
  end
end