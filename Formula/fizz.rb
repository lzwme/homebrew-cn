class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.03.06.00/fizz-v2023.03.06.00.tar.gz"
  sha256 "54d91581da093d70cc0baf2a391c0bd64b6015dc70c90c1111c2a4d40240f5f7"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "50c1bb798187fb5de06edb17d6fbe2874de1ae39de02bbd9f2c193862cb79c30"
    sha256 cellar: :any,                 arm64_monterey: "eeb7c376d075666c01fff6e6c70e1c9974a5789093c98cef37e7e7c46a289155"
    sha256 cellar: :any,                 arm64_big_sur:  "16b1aec78492061fb9af20cdab8fe5f3756f45ac5d71c3671b831eb498adbdea"
    sha256 cellar: :any,                 ventura:        "cf3ee7e532c34d237ccb984582c9efab5de0f46a861429b29ef3e596c0af9cfd"
    sha256 cellar: :any,                 monterey:       "fa41b67c50562e18bf39aa19ddce3f785c490415c020522755e6ab010e9c06a6"
    sha256 cellar: :any,                 big_sur:        "41f71c21919ac8b9c81452840ad97ce48b87896b125385ca311b92bd27d4b446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae3a86745b4875e362178ab512107662334f99c470a806fbe341ed6a07a577c3"
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