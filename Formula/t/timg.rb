class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://ghfast.top/https://github.com/hzeller/timg/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "a5fb4443f55552d15a8b22b9ca4cb5874eb1a988d3b98fe31d61d19b2c7b9e56"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "483bf681c8b822ef5271e84cd4c599c5425ec8a0b28cd345a320f68af2b05617"
    sha256 cellar: :any,                 arm64_sonoma:  "aa033521f4b1ea224bc84058d7fdbda534aac3f1a65318f69d198ae0b17990b7"
    sha256 cellar: :any,                 arm64_ventura: "072d74e851550ad40d8c4c6011ea488adc1f4ffbffbcdb26f3cdd08bba2f9faf"
    sha256 cellar: :any,                 sonoma:        "cf7446cd124bebfdd8d9a3b260bdbe554837baf0d1306f723fad5db7df46c2b6"
    sha256 cellar: :any,                 ventura:       "59848ba255ac59552c72931388d576b0c3ae8656f8d8e8076660df4a2b723730"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6fb0793782cb954bc2223399b8f17922187f91e0834940ceff2db630e571052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c55773fb422d5931ac926c0e6c3ddf52f437a0ed46974951cf304ce781990b24"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "ffmpeg@7"
  depends_on "glib"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libdeflate"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libsixel"
  depends_on "openslide"
  depends_on "poppler"
  depends_on "webp"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"timg", "--version"
    system bin/"timg", "-g10x10", test_fixtures("test.gif")
    system bin/"timg", "-g10x10", test_fixtures("test.png")
    system bin/"timg", "-pq", "-g10x10", "-o", testpath/"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath/"test-output.txt").read
  end
end