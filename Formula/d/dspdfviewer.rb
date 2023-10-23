class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://ghproxy.com/https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 18
  head "https://github.com/dannyedel/dspdfviewer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e17d64b17e955a832d29b18712b7bc273d8cd5104a3730eb88fde62fde0d88e"
    sha256 cellar: :any,                 arm64_ventura:  "5e02f7457a0b19d3047dba80bd49307d782713d4423e470ef2982ab7ef38095e"
    sha256 cellar: :any,                 arm64_monterey: "e95bf8ce72967e904db0226f5355be039e70c755b751ec774887f05ad23c138a"
    sha256 cellar: :any,                 sonoma:         "767ae20c7fe172cb6346841e6b1f90eeb9a740a1a4e2d0f5a73769c8ccb2c87e"
    sha256 cellar: :any,                 ventura:        "38aa57a8f5a30028f80cddd51792d31b3e84f282dab928ad25ec98763672658f"
    sha256 cellar: :any,                 monterey:       "9c633d4abf52e5e5888cb8712fcb25eb178477509f025b6d890d944aa7afee0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f463225b32cdf4c4ed4568aec1d15adc44e8ce3b7ad993be3a0ed2d05c8f8762"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "poppler-qt5"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DRunDualScreenTests=OFF",
                    "-DUsePrerenderedPDF=ON",
                    "-DUseQtFive=ON",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DCMAKE_CXX_FLAGS=-Wno-deprecated-declarations"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?
    system "#{bin}/dspdfviewer", "--help"
  end
end