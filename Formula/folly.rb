class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.05.01.00.tar.gz"
  sha256 "7448d114e4384693930cdaccc80dc382d3deafea556043b3c3a4696fc9aee02e"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "830a60173729a473cafaeeb93a0f5020ab30a7f2cf54fb34f8af138075eda5ca"
    sha256 cellar: :any,                 arm64_monterey: "012a39f70e5d54c3bd8d20171d8dc86f2d3c13ae6df742005b7cd892c342a623"
    sha256 cellar: :any,                 arm64_big_sur:  "c6b1a9d325eb8f75839e2203f2463e963e0718de90f3e99cd5186379065c946f"
    sha256 cellar: :any,                 ventura:        "9d8de798ef5946b57a333ab42887d5a14337fe5e93c12dbd2b08ef7b408c3d34"
    sha256 cellar: :any,                 monterey:       "c9c703fc57e201c53ab0d56d51a664f3264ce6270f4b19094e6fc21d53c52fee"
    sha256 cellar: :any,                 big_sur:        "6a9819dfd35b7a5ec3288397e3122f0833a0920a269200cd29a3dd198d956f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca619c2378c43b6106944f7d02a035524d6b57b910302e376af7ebf148be0b75"
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