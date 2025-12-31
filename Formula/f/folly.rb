class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghfast.top/https://github.com/facebook/folly/archive/refs/tags/v2025.12.29.00.tar.gz"
  sha256 "0e48637300a586f3bdceec7e81147dffceb6bea8ef87d5b57df27f86a4a93fe3"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5235a47894d49c9ffce28c6b11a8f196cfe37b8841b2cddd3236de66ae21f045"
    sha256 cellar: :any,                 arm64_sequoia: "04c08f1277a9c1b8286b2a5f6e9d24f6d7c5b455577fe0ef202895ba8ed6550f"
    sha256 cellar: :any,                 arm64_sonoma:  "0fb24f9bae94385b75ad300a9ad2295f779add4b19580077c2e2c32ae1619278"
    sha256 cellar: :any,                 sonoma:        "9a3b0d47d293d014d405530402333d83e5db46af19d62ac31fd750e2df7222e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b8ac1269515ae45ec2f75908337555318bc572630f58ce22ac7be1243d5997c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "514100cb502d32865a92f976a36f051e861e54d7a0303251ac29ad0c6fe29236"
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