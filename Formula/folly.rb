class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://ghproxy.com/https://github.com/facebook/folly/archive/refs/tags/v2023.05.15.00.tar.gz"
  sha256 "6654d7f4ef5356cf2af6fc8b0f98dcac49a09a53f66557b01203b6eaf252864b"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "915fb6170caa0f11120142a0639b6b99effd60e234bcd92ead432d0e449698ca"
    sha256 cellar: :any,                 arm64_monterey: "f0b519a69241404a95f87de0e02bc82855cf9ee37755271e5532365f9033d732"
    sha256 cellar: :any,                 arm64_big_sur:  "a20762505819d194597081ee4d4ebcdbfb6687f63bf765a54745d7874ea0441c"
    sha256 cellar: :any,                 ventura:        "61029559d40e9c657ba19f318854f23854cedc3a033d17ba618d995428985fe8"
    sha256 cellar: :any,                 monterey:       "5183efae79b3c47d80f2c289ddb7f3aedcb8c8f8c4c45a3b2b8e0e5e3843aeef"
    sha256 cellar: :any,                 big_sur:        "36a72df03cd6dbc72e76476ef62ace98c4269b11d4173f76bbd779fc3a4235ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea0e82a1d597626a1344567df09976c997b3a5f80c6db742b9bca77ab34a9b6e"
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