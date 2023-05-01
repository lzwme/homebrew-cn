class Matplotplusplus < Formula
  desc "C++ Graphics Library for Data Visualization"
  homepage "https://github.com/alandefreitas/matplotplusplus"
  url "https://ghproxy.com/https://github.com/alandefreitas/matplotplusplus/archive/v1.1.0.tar.gz"
  sha256 "5c3a1bdfee12f5c11fd194361040fe4760f57e334523ac125ec22b2cb03f27bb"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63df998410641e7a87ef3f803656ba9a5e4db197e2a2f67b457b61ab042c4c2e"
    sha256 cellar: :any,                 arm64_monterey: "09fefaa3f06a0139757348b66ced9a78e9cdd89b359eeb8bddd86c11ba328c76"
    sha256 cellar: :any,                 arm64_big_sur:  "91e6a335dc67dc2f53f3b530fb8ff996552b8ce5df746bcd542214cf0fbaaba1"
    sha256 cellar: :any,                 ventura:        "aeb9853045a5e8498f48b4095c6f144fbb66c8bd88b8a0d88a8da1bd2af6d793"
    sha256 cellar: :any,                 monterey:       "ae78e44903b2ac5d6172eae41cf93247a2d8b96056e2e7e3deff8df85241c9e3"
    sha256 cellar: :any,                 big_sur:        "c20d6f3472a9f7ad51c37e28f9831775609536a45e98d9184a5612676c862293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d9fcfe3e375a750c536a1e93760be3e700c7c20ea2e2cc76d91577e2f4b420"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gnuplot"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "zlib"

  fails_with :clang do
    build 1100
    cause "cannot run simple program using std::filesystem"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_EXAMPLES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    # Set QT_QTP_PLATFORM to "minimal" on Linux so that it does not fail with this error:
    # qt.qpa.xcb: could not connect to display
    ENV["QT_QPA_PLATFORM"] = "minimal" unless OS.mac?
    cp pkgshare/"examples/exporting/save/save_1.cpp", testpath/"test.cpp"
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lmatplot", "-o", "test"
    system "./test"
    assert_predicate testpath/"img/barchart.svg", :exist?
  end
end