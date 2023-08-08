class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.08.07.00/fizz-v2023.08.07.00.tar.gz"
  sha256 "01b01061f4c5e90fcd39a7bc3cf4afd5d9da4fb352e065ab345132617dd2f6d5"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "092295b6b5ac38dcd16186ff75b5b196cca9117c440e6ff3181f4af52481d848"
    sha256 cellar: :any,                 arm64_monterey: "1b33ff11cc3d041020bd48130e02917645ef265a03be8992ed611a4786946bac"
    sha256 cellar: :any,                 arm64_big_sur:  "ba8847a77bb2204462120c09f63d380a15d3eb674d4809544b688a824a422a81"
    sha256 cellar: :any,                 ventura:        "3b39094f4e366e63ee0d3ea40f2e9306e85952d57b021c461edd3200c2f5ea09"
    sha256 cellar: :any,                 monterey:       "757b8c15f3e258f219f03532bcf4221ede1125a1ab3eafd008cec60605ceccea"
    sha256 cellar: :any,                 big_sur:        "db76b0374cf379479f62ee8982875004027338ee820a81ad0412d5dd21bc3a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08eb70d7aa6c6098eab547bd86cd040164aaa6212315a4e20b62c7e825773923"
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