class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-24.01.0.tar.xz"
  sha256 "c7def693a7a492830f49d497a80cc6b9c85cb57b15e9be2d2d615153b79cae08"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_sonoma:   "decb6a0f57a25de2123210dd5d3963ef4d86c54f5e8eed8b6fb2ab3917506dd8"
    sha256 arm64_ventura:  "3a6b564b7c800e8f3abb1c9e4865794be1caca1c7c2e7297a25fe508b3c8fc88"
    sha256 arm64_monterey: "702a4e6b5c3694f880725bdcd293ccd0a2e31d3d157cab379022551cdd995f98"
    sha256 sonoma:         "9780e363166e2bc397b8f5e47d64091cf7d40891da377b29367b18da7af37211"
    sha256 ventura:        "c49e3c4ef3b9dd69b131afcf33aab979c2ad4ef0fbae447ec04f31f67b946a12"
    sha256 monterey:       "31595f96b3147f5c2cf74652bd37a9ceffb736361e9ce750c9abb54a2ccccfd3"
    sha256 x86_64_linux:   "884e28367c8a664aa3bae24a52bd63f618db2b47428b39f33895e18c782c20a3"
  end

  keg_only "it conflicts with poppler"

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"
  depends_on "nss"
  depends_on "openjpeg"
  depends_on "qt@5"

  uses_from_macos "gperf" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.12.tar.gz"
    sha256 "c835b640a40ce357e1b83666aabd95edffa24ddddd49b8daff63adb851cdab74"
  end

  def install
    ENV.cxx11

    args = std_cmake_args + %W[
      -DBUILD_GTK_TESTS=OFF
      -DENABLE_BOOST=OFF
      -DENABLE_CMS=lcms2
      -DENABLE_GLIB=ON
      -DENABLE_QT5=ON
      -DENABLE_QT6=OFF
      -DENABLE_UNSTABLE_API_ABI_HEADERS=ON
      -DWITH_GObjectIntrospection=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", ".", *args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF", *args
    system "make"
    lib.install "libpoppler.a"
    lib.install "cpp/libpoppler-cpp.a"
    lib.install "glib/libpoppler-glib.a"
    resource("font-data").stage do
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end