class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.04.0.tar.xz"
  sha256 "b6d893dc7dcd4138b9e9df59a13c59695e50e80dc5c2cacee0674670693951a1"
  license "GPL-2.0-only"
  revision 1
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_ventura:  "d60dc8e214090dc089e0aed397751d36fad10df943968ffcc8853aed2768287f"
    sha256                               arm64_monterey: "a502fbd2575dbb981c715b8770ad32b12272c90b0b5847a24978c5bd9acfc2ec"
    sha256                               arm64_big_sur:  "76f756e030c3eb4416bf2ea3abe1aefb0ea752ebca3ccc0beda8a41a9d7c403a"
    sha256                               ventura:        "857839890c72885b3e23893ee305749279fabcf8ddb39ef42cb58a55fc2740e3"
    sha256                               monterey:       "14d088523abb3ea94473ab8f89b92aaa425b2ddb69953cfe333d611784711e83"
    sha256                               big_sur:        "bef957d5ca16e203e82e20b386b4f5678ec4d172f2124e7131a3e983022b5530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826f5ccad61fcd5bdef1796f530b070bd5daea91af7fd15d46af3c824369b3f0"
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