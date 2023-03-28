class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/v2023.03.27.00.tar.gz"
  sha256 "107fcf9c679a558f6db7792f9bda7bd4e4b035af4b7396845571106381a8556a"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b74361104d3e7fc9c20858dfb6117f6495334a2b09497949deab7550b8d10cc"
    sha256 cellar: :any,                 arm64_monterey: "8490c163d4d258a0a888c9882b552969ddfb059fffcf9f15d2427aa1be21b17d"
    sha256 cellar: :any,                 arm64_big_sur:  "dfb8eee06be25ea1f786e7c5c63d90aa845446680c2ed691114653028ab87155"
    sha256 cellar: :any,                 ventura:        "c458c202ab1470c0173900deea6b78262bc7da5848a827f230abfdd36563fff9"
    sha256 cellar: :any,                 monterey:       "25381a89e792369797981f01e38309de4b73106b1f21b79c72683309b8e12f4b"
    sha256 cellar: :any,                 big_sur:        "d7a3751fb156eb2f5d2600d05837e566ef22a7843fefef766b1a918428b1392f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445916998f7e24e57b710a0ef95aab95b8bdd07e50f6220919d3cbb5c847efb6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = std_cmake_args + %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end