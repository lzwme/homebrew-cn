class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.12.0.tar.xz"
  sha256 "beba398c9d37a9b6d02486496635e08f1df3d437cfe61dab2593f47c4d14cdbb"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_sonoma:   "cee0248a585b9cea1a6652c5ed2f8dca37726b74f1c4f4b89d959a744e0271fe"
    sha256 arm64_ventura:  "0ecb028718a6f16170a4e598354cf6288cefd1a26fdc94c02d59d63e27e6be31"
    sha256 arm64_monterey: "1e9a1ed559e82ebc25e660e998bd9825fdd3cb93aed31e7b2490280414186f84"
    sha256 sonoma:         "bdfccbf04184a718926364c6666788ebe4d17fa2c355969065b2a0d5ac58b912"
    sha256 ventura:        "16f5b583aa71074723884438c08c2f6202ca1cbe43f7f58ecdcd8c98f9712903"
    sha256 monterey:       "2b87da8b59150a7ee0c26d1e899047ed1c6b73b00b63e6526425bf468704539c"
    sha256 x86_64_linux:   "cf3f153f6fe698b2bcbb0f6d5592b8b25735f05b89a636498c7c8d16c18705df"
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