class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.05.0.tar.xz"
  sha256 "38294de7149ebe458191a6e6d0e2837da7dba8683900a635252f6d0ee235f990"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_ventura:  "55a708e667644f66ae6a99c83f22578d666296504ea76503ccf906fca2d88176"
    sha256                               arm64_monterey: "2e895db73feaa568c4bcf20bff337b02e453c4686d88e1de60abbd09edc8ec9f"
    sha256                               arm64_big_sur:  "5a5b4ff2b34f1c86f627339db7fa7292bf10609fc75f7f8a55bdcaf4071812a1"
    sha256                               ventura:        "97c72a0fb11a16c906defaef329db8a08e5541f304804a78d0c9a6eec7a8405f"
    sha256                               monterey:       "effc8e0f9542efab2c1cbbddea9d18f98d5a240ea9338acb3e11a79544e8318f"
    sha256                               big_sur:        "7b2fc317cc1986e2c2a63f2adf9146463d42acf3cdf3aecf7d1f97c9031eb545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a726550c3bdefff507522cdfdd0437db967b83d026c26e41a441633858c4dc"
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