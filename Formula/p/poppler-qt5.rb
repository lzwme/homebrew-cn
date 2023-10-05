class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.09.0.tar.xz"
  sha256 "80d1d44dd8bdf4ac1a47d56c5065075eb9991790974b1ed7d14b972acde88e55"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_sonoma:   "d7c8f2753b6345055892ace79ea3c336cabe00cfd22fa8800fcdefb39a10ce10"
    sha256                               arm64_ventura:  "eef41983167fdb06e68060363de17be437bb0cb94636031847558b8e55ddcaa4"
    sha256                               arm64_monterey: "af85d66c9233696292f1811e461dfca6a5690734b41e7f6b3988e43e33f55a13"
    sha256                               arm64_big_sur:  "8d769f2b1cef4795307776f321362709ce4e328742dd9017aade20ea5277b807"
    sha256                               sonoma:         "0571a6514c9f27a3a1e586cac676bea148261d5b2be63bb6002bc09a1d0a7946"
    sha256                               ventura:        "05aa0354d59deaeb64f46e10c2ce8b7e8be0c27d63d838120b933f65aa549cd7"
    sha256                               monterey:       "a47ec4740e0f5a71f6432b86e4015b1add3548022ec5cd8e4c4cd91ea9caae21"
    sha256                               big_sur:        "a1ba2e156cd95bb4566263a0aa07fca23630b180195f3e39a82bb5737d29f862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "152ca05a2d1c3e89c4f8bcc386cb21082bc5a147ee8ea9a55f5c008c8e91215f"
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