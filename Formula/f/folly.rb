class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2025.07.28.00.tar.gz"
  sha256 "23eea7d7631b76c79f97094d618c772c62d863ed71c0bfa3eadd64b86eed1d64"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48495d92ebe7f3654cd2d24f7ae25bf98043e5f74cf233a7286c8dd041d9e84a"
    sha256 cellar: :any,                 arm64_sonoma:  "e4f269513ee828174dcdb06e4fa788a160c3cb19bae9810660ad5831d2bc239e"
    sha256 cellar: :any,                 arm64_ventura: "d09d491b20f3800b864f82057dbe9b5359281374012942413e99de085201fbc0"
    sha256 cellar: :any,                 sonoma:        "96aad8073367b0ae6a6f4431a0466ff046140f92a7e075416bd09c2268247539"
    sha256 cellar: :any,                 ventura:       "c6a191972433931cbc16eb29dbb1af5945fb97dfd439c239713935dcbcaa7223"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a45d44b53357b2f19c98e94595dabf5317d5aabd9d1897053e0556f6bb2d514c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dcc96bebb9c548fba2af9da9947880fc42c7f7e1d5c4cdea6c92527c167ac70"
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