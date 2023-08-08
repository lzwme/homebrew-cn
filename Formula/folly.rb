class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.08.07.00.tar.gz"
  sha256 "103d9454ac03dfbfa846b90a4b1b444df1cecc7a9d16caa1a4abd93460f7b422"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c1e69a2ed8c514093e2d3e482dd48bd16446129cf589994a0872a6ed6ec3f84"
    sha256 cellar: :any,                 arm64_monterey: "defd7ba184ad386c0b878eeb2bf700fed8eb6b75d985453402eaadddf9956ef4"
    sha256 cellar: :any,                 arm64_big_sur:  "bd201bbcdd7ab0170f835055ae96496ece9fdf03172feac8590518b22b01ec79"
    sha256 cellar: :any,                 ventura:        "6905dc9b300d2e06d5dcb91fbd18cf7e3ff01c5e575551fa99090a7d4d67ca12"
    sha256 cellar: :any,                 monterey:       "bab0279d7e78092f0719ceb940ac631daec9b5e2d1c475ff58dbac0a40ab9f10"
    sha256 cellar: :any,                 big_sur:        "ee97764f2e18b88e29e66b007570ac86630101dfb14fff143c27adaed63b5057"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dad75ebe26a71a18f34f70100b9bf428e547480047ec470798d44497447cd57b"
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