class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.07.0.tar.xz"
  sha256 "f29b4b4bf47572611176454c8f21506d71d27eca5011a39aa44038b30b957db0"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_ventura:  "fc844eeb14bae4cb6d833fa8266cb95cfb6eee69d6155532cf12aa512ab2f5a3"
    sha256                               arm64_monterey: "4df43820f85b02583e151e610187000606be0b109356af78fd050012332fd4d3"
    sha256                               arm64_big_sur:  "e9e8351a66d316a62e1b7ca00f4782068e389a3ea1cf15c96aa0804283ea4923"
    sha256                               ventura:        "aa5d6b149ea0fcf70846cc6b90bfa9edbb66e660077d35d1b65711ce452ea3b9"
    sha256                               monterey:       "b7e0f455a79c674c4d4dd67d80a7d443f271c23d714c2be233e5a0f5e3409850"
    sha256                               big_sur:        "f66967fb7f9f88fb12b13a791e1958779766c2ac736e035f50c24933d02a3f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1300c03c57f4bfc0336b6b66c95e1a58f4e43bfa7b8387d316e3e919ccfb1c2"
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