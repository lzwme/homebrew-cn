class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.02.0.tar.xz"
  sha256 "3315dda270fe2b35cf1f41d275948c39652fa863b90de0766f6b293d9a558fc9"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256 arm64_ventura:  "fa002b7fcb8196248474a757515746498463cfc6896a310877e16fde149d4e93"
    sha256 arm64_monterey: "51d8031e8281db8fff6ade85e7f1e722a0bb0566457868d61c6f8956bcdf9a3c"
    sha256 arm64_big_sur:  "916172ee7d139c491e6782dd87190873a000aaf7fdc550d0c542d23b88ad12af"
    sha256 ventura:        "6e833fb9944be13e4698e54c16b6711a14d367dac138079da253e7b3671254a0"
    sha256 monterey:       "16bab7a651687b690706c81b8dc67d18d5e29250158cfc5abc3bf2b21c71ea54"
    sha256 big_sur:        "533deeabf1169a7406057763ea73615837e8131afb261570328213a7c75871a3"
    sha256 x86_64_linux:   "290353d7c0acefff803e7d76028f4e54d6edf4504588ab40ae9ba43c83c1c6b5"
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
    url "https://poppler.freedesktop.org/poppler-data-0.4.11.tar.gz"
    sha256 "2cec05cd1bb03af98a8b06a1e22f6e6e1a65b1e2f3816cb3069bb0874825f08c"
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