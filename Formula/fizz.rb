class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.04.24.00/fizz-v2023.04.24.00.tar.gz"
  sha256 "a66ed96f623efc42cd5b96f7d1749a2ac2c761a2d1b84ec228f72579cc420c03"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "014af10320662878dc1aa7e23cde1d6b625349b29edfca7b172a76e964b99843"
    sha256 cellar: :any,                 arm64_monterey: "2d7476424209f847a000d30530664238e4bf868257d7c9b2cec8d89521921db0"
    sha256 cellar: :any,                 arm64_big_sur:  "f4210bad7b76d3a7d2562f518c855d0cddad51f7634c7a219298551a2f8cfcc5"
    sha256 cellar: :any,                 ventura:        "49dc21989cc422e8adc22a40866568a7019c2a4e7e3a106ed49f6ac760698898"
    sha256 cellar: :any,                 monterey:       "a270f1c9a7c398181e39a751b8c5a12622fe31612afadf7800f4b6b9373798e7"
    sha256 cellar: :any,                 big_sur:        "0b5749a1f90de8d95e61703a3a9039c702067bb9c709daae70491fdc67d88292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "319a520ff734afffdc264eec1e4a497d1c3d8d67e4b397b2fafd3bb0ee6092dd"
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
  depends_on "openssl@1.1"
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
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@1.1"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end