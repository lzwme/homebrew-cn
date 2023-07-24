class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.07.17.00.tar.gz"
  sha256 "d97b3054b2574ea08a7db9a48aa62b56142770dfe4a76cc8347f89a2b7e9bacc"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "61727eedd97c98b7703db5ea5e5de6896420dae97bc33ab29c7157f5f3c4c61c"
    sha256 cellar: :any,                 arm64_monterey: "68a9d83f3834d8363917ae21d35f825d252351013fe3fca20f120c9eeefaba93"
    sha256 cellar: :any,                 arm64_big_sur:  "96d78073210c34cc7b61e84496aa8b79f0fcf6afe9633c6fe6b78e9fd4b20f06"
    sha256 cellar: :any,                 ventura:        "87a4bf28d7c35e52d22120f8ef9fe80675b4596bcf0b775d79414e4f665e9f41"
    sha256 cellar: :any,                 monterey:       "9c54002c7d1e1715d94f33191db35924719c9cd5573e3ef5978aacfcfd4b909b"
    sha256 cellar: :any,                 big_sur:        "ef75c6bf420c346d07926b00b8a2c94fccab5fd8d034f5cd63a3a3736ea912a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf9456c798fad2467ce7635506079ab1bef5c5675dc3ff5a999ea92f2e82bf03"
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
    # https://github.com/facebook/folly/issues/1545
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