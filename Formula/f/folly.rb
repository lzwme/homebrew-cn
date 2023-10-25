class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.10.23.00.tar.gz"
  sha256 "3347de2760c958f921fd05dc8140b0d16cac295233c4a1c57bc49f907ebeba7a"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8cdf94d8d66c3c88a91a5e8f89ee2e4a96e7e384072aae1bfc353e15ea5f9699"
    sha256 cellar: :any,                 arm64_ventura:  "fbce5bcafada8b721edfd362bef01e32044b27a981bdbb8477040dc8200fbd6a"
    sha256 cellar: :any,                 arm64_monterey: "58c6bfc174a303634d32dae41efdabfb293048210e773fd9606d963dc5669c97"
    sha256 cellar: :any,                 sonoma:         "81915889eedc471fd63838bc6f59e0ca9c4d65b6363bd3e7ac6e1822c2a74770"
    sha256 cellar: :any,                 ventura:        "19f762c50cdc1ae52bb2f4c02beb2bb248462f12b7abe027a9a54ee54f6b9f14"
    sha256 cellar: :any,                 monterey:       "133034a29ba667d53b39a914b211dff44be100a3b6a09c9afa138ab2f3d91d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa8207dd6167bf179882f16e4291d7be9448386f10cc299ce71d3f9f97aed66d"
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