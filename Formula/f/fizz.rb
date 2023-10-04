class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.10.02.00/fizz-v2023.10.02.00.tar.gz"
  sha256 "f0103ae08a1459f89fe5aa4fba4441319de27ca1c3801a837e732049e40aad9e"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5ff96fa186dfb447c894b2cf626108ef0a7d55c7823413c0deb51334e6e05341"
    sha256 cellar: :any,                 arm64_ventura:  "4176ca25234855a3d448f747aac154e3255bb4bcac5334b1952348858be8fc5d"
    sha256 cellar: :any,                 arm64_monterey: "bd34c89aed227c095fb6d6d878e5ee5ed1ebd6b8f7c6198528751da58c952baa"
    sha256 cellar: :any,                 sonoma:         "4014df66e75bcb63a483656faf41dcc227fd66f7bd8209c4ac15c749def39994"
    sha256 cellar: :any,                 ventura:        "4c196ace83e1f14c19485b09568012d01efc9330a2e1a53085cd60fa002a45bd"
    sha256 cellar: :any,                 monterey:       "694100119a1f6635587a7c6d6b5fc02416b2916ac8e6d1763e860c276ab59cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3f233e997496d9970ba8ffc77a4be26b6c67ffad87d9a83b82d1e510eef85c2"
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