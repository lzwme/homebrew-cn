class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2025.10.27.00.tar.gz"
  sha256 "03e0b9973600afb989072bf7abbe736371fd559d4ac3bfdcec181053ea21d99e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ee5870a769990cbb5d7ba12b3982f7648d0492b43b5b3672288c3b3207d8a6b"
    sha256 cellar: :any,                 arm64_sequoia: "36f91d7b033f1d6f0babb3c6dc431fb33224c7b3e74bb74839d0b4ad09784cfc"
    sha256 cellar: :any,                 arm64_sonoma:  "87f3a8a47a9f7f194cb5ed5a97377810abbd31fb02ef7e1184e91a51513a611d"
    sha256 cellar: :any,                 sonoma:        "2281eedbcdf6eb2ced10fe0ea1f5d4dac75e8c9e26d15c8714f4321bf75b2762"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf30741cce9ba6494df752e1be6888ed4ea1e9a01cf2d637460663b0a152f9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dbd986f7b09f18d0375a9f42c332db9d5d8dbce05c67e3aff8872d4452bca27"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath/"test.cc").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end