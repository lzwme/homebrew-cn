class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.07.24.00/fizz-v2023.07.24.00.tar.gz"
  sha256 "5d063620c36cf1a6fc9e996fdec30a0717ae15ac494126c753a618c01a684854"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bbef91e37b870130c49e29fdd69b33df8a42e378ddd7f7fa7c30205b4c060d60"
    sha256 cellar: :any,                 arm64_monterey: "c7147868c46601d18a1ac803484ea114ba9f43f95f5d2b1cbca4154765e1389e"
    sha256 cellar: :any,                 arm64_big_sur:  "6fc2846982139b4de0bff2144fef7c87f4ae121775fb4358c437126eb50e37c0"
    sha256 cellar: :any,                 ventura:        "9e55bfb7cb40253a6f5196772d0de7faf88305693a4556bead35d9617ee32270"
    sha256 cellar: :any,                 monterey:       "bd8f9fc0966e1f3caaa271bdcfa542acfe673bd3b06c1dcea5e690b328437a44"
    sha256 cellar: :any,                 big_sur:        "5889cad51feca87aa896fb0b33a341416f837904f5424509274751ba1c28f31e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e2feda62a1f310ee452085e224c284e85b4dbda9ad8fc01f10e0f7f6e354b5d"
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
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
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
    assert_match "TLS", shell_output("./test")
  end
end