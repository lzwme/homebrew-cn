class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2025.07.21.00.tar.gz"
  sha256 "9c324cee559c30c727ef26df1a35d0f5ab05445a68bd920ed454900101aa4938"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "353700efa5255f3576a0a97b3f22767dfad28fe2dc7b67b0ae0f8ce689267e1d"
    sha256 cellar: :any,                 arm64_sonoma:  "8755c5da79f8458736bb4f924a9becb6d724636855b94ffaf62c09ab418b0241"
    sha256 cellar: :any,                 arm64_ventura: "c7f8c731b8e68a821b3d72664f5400390f9e01ed04fc30576119220aebcdb35f"
    sha256 cellar: :any,                 sonoma:        "95401b50f697cd5907f0e78d255ed8e33a95552592f6743b108fda70711e4930"
    sha256 cellar: :any,                 ventura:       "c67530a2bd47d8c0a0d7bd784637be1d88488ac13269d441669f059bf2013c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0c2ac47fe1e00abf7ffd43594d827ce73399d3655ca1d4a089901c1c5facdcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaea7294e405179f8044a26c1de7984fbf2506a437e25eb946bf9ab3537f7805"
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