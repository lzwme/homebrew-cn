class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.04.01.00fizz-v2024.04.01.00.tar.gz"
  sha256 "3fc4b2ddf2491672ab8602bdfe5b3beb4e29a2e38076bd5d1d453e403eb60380"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6bc9948af5ebbbae41c60216fb52953757c3277e716b21a4755a30ebd38752e3"
    sha256 cellar: :any,                 arm64_ventura:  "f5433338bf008e500533bb6a3982dd4a7230b6829ac378787f87e5c2442b8e30"
    sha256 cellar: :any,                 arm64_monterey: "907ba9d519212c0a4ec5e04466af8d7a4251ce14faa8d67610b62399e863c62e"
    sha256 cellar: :any,                 sonoma:         "1469cd93546a61899b3a5d0d4ec8934c98c199967315b0dfc303dc92b35265b6"
    sha256 cellar: :any,                 ventura:        "7637fc7d91f393b10c7c735b71f292a88198db80b70e8025f2cb345d6afeaccb"
    sha256 cellar: :any,                 monterey:       "8671af942860e350a237c2fe489b34a55cba4796db3810ac46630159b01be3e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c1431cb92c4217d3527d868d75930a8681b2e8c520e9fe314a8213e2fecce5b"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <fizzclientAsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@3"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output(".test")
  end
end