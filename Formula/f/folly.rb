class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2025.12.22.00.tar.gz"
  sha256 "4f863be530f789a5b72bdad36fb07719a81973574b32028fafbcf0d53a7ef202"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c52b93830ded8c2295719a2608f19a29fd5fd1d730f5ed0d381e7371cc5ab9fd"
    sha256 cellar: :any,                 arm64_sequoia: "847b4cc1cfa5495f676246946a74745e95a4fc97866e2b98f7e649b45ea83a9d"
    sha256 cellar: :any,                 arm64_sonoma:  "a7d0cdf5fdb3e6d660fa892432281df2594c12c31210df88183ac8b3a0c73557"
    sha256 cellar: :any,                 sonoma:        "397eb5d88f8d008b5f30219e3628e246b00952bb4317baa21ea23025bf45837d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16991702b997bda7b313e7df753d4f4e3dc01580de04b3719f6ccc75923736f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf9d106791e6f905edc0d47f6a1b0d7362bd75ce1b2cd2fe62e3e3603e96873"
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