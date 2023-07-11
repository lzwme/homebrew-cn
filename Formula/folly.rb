class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.07.10.00.tar.gz"
  sha256 "ee4346f6dc9288bbcd8b016294669fe16cac36132c33ef039286962f85229250"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "917a139090225b572fb12dd13f4744e50f962720b3e30a3371182f1ead80a318"
    sha256 cellar: :any,                 arm64_monterey: "95cd2b849785c7e71d5a287d732e29ceac8b85d7ca2c969f773739cea4e0d8c0"
    sha256 cellar: :any,                 arm64_big_sur:  "2e51942ac87c268e3e7fb2364f3f81a02ce3cccb74cce019a5b81cbd52f6b739"
    sha256 cellar: :any,                 ventura:        "eeb32b3d116e63a428f47d76cc28ce20cc3ece8ebf7e488dcededd310352a31d"
    sha256 cellar: :any,                 monterey:       "6cb71de9b29c782e757b409d8a546e1bc0501e765ec74827fd5631dd91eccfee"
    sha256 cellar: :any,                 big_sur:        "7885e2ce711c63e22981b5084ddf79fc4f1f4eb410dd63c8e0088cc9aba30e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ecbcfbd744a4d5ae0c551893e8633a2c6662bb4e24032b459fb3d271470a88e"
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
  depends_on "openssl@3"
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