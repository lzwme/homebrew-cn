class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https:github.comfacebookfolly"
  url "https:github.comfacebookfollyarchiverefstagsv2024.05.02.00.tar.gz"
  sha256 "c220c556b69ddd91fd83aa2682c7c60470d23d9157e27c803e27f795aac0da9c"
  license "Apache-2.0"
  head "https:github.comfacebookfolly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "79894b94b25de6737801acef74951990fb86cfba550c9ef791978ad7e3fda213"
    sha256 cellar: :any,                 arm64_ventura:  "e106d6b9120f7afa2cf4604462974260d5aa264b851924809b96c3b683965c8e"
    sha256 cellar: :any,                 arm64_monterey: "dc6141f3a6c63d7c5b652bd3233ef34ae498929c8a0e21dab37c816c53752ae2"
    sha256 cellar: :any,                 sonoma:         "7e53609bd80158281dad7025907bf3c520770ebbbfc87c0db1bea7fb8b69375f"
    sha256 cellar: :any,                 ventura:        "9980f2a94126534e4cbb5f6ebec8fdceed867157fa42327e20f6b0146720b66c"
    sha256 cellar: :any,                 monterey:       "b1186df558656b1a710aeeeb0eb0e18b21f0796a6621fffb698bf11743dbf0b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5517edf7cefcb5ac5bd2e41d3d1fa8cc5b683af103fbab2bf77238ecca09cc0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https:github.comfacebookfollyissues1545
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "buildshared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildshared"
    system "cmake", "--install", "buildshared"

    system "cmake", "-S", ".", "-B", "buildstatic",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildstatic"
    lib.install "buildstaticlibfolly.a", "buildstaticfollylibfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

    (testpath"test.cc").write <<~EOS
      #include <follyFBVector.h>
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
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system ".test"
  end
end