class PopplerQt5 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-23.11.0.tar.xz"
  sha256 "f99cca6799cb9cb6c92fc1e0eb78547b611cb733750ab7cb047cb0e6c246539c"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/poppler/poppler.git", branch: "master"

  livecheck do
    formula "poppler"
  end

  bottle do
    sha256                               arm64_sonoma:   "c0bb20ad9b17588af29292ecddea346dd819d3b977f09c812dbabae043df4d0e"
    sha256                               arm64_ventura:  "4817b687b40324fe420b6d3140c26e21a7cd5b2f2de3ed835e1f1b9f4341d095"
    sha256                               arm64_monterey: "63bcf327ed791982342ce6029e14a75e206bdf5c189873ffb85b83ce7cb31885"
    sha256                               sonoma:         "7a8d7b75f6048813782c3658aa7da99a15e7c7cde4897a8137deb3c14b45459a"
    sha256                               ventura:        "bb0123e78734342a0f3c829ad65842e970612495bdd609865b65af34fba98d77"
    sha256                               monterey:       "81aead423eae0f13783b67dfd9322d5ba2c37c207c1bc862671136275a9c90c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d4cb77fe8c6ab2e907b129bd250777448a745bbedf5ad7a9cde78614760496"
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