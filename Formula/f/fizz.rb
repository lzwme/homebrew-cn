class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.10.30.00/fizz-v2023.10.30.00.tar.gz"
  sha256 "5a33aa99d8dccc1daa7eef763c72e00ac471ecbcd832593078e7d93dcb143bfd"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "879bbe74ec8172d4e1be4269b17e26abf6e2939b7e397f40845dc145917e0b49"
    sha256 cellar: :any,                 arm64_ventura:  "0d5b1cc015c524969959319b98daa66e74f7d904d76126402a172efe7f247dc8"
    sha256 cellar: :any,                 arm64_monterey: "f0ddbb0c4ecb91d4c33f0b5b6b425014ce44dfbb8eb6a35084bb18c0726f86d8"
    sha256 cellar: :any,                 sonoma:         "ff13c3047f0524f0e613b830ac4fe7fbbaf8bcaad164715db1d33735978f6e20"
    sha256 cellar: :any,                 ventura:        "387866486a7c0894fc15968f769964192b9f0e72650fc2c1f5f47dcb73ed921e"
    sha256 cellar: :any,                 monterey:       "a35ec081f063d89851c7c5854dd1de97b18f023fc16e52b4c2072ff076a4616e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c733a2d1869a7363b44cb12ff6315b7107b239a71d23e96bc07caf1bcf82a444"
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