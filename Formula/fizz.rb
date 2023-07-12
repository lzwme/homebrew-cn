class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.07.10.00/fizz-v2023.07.10.00.tar.gz"
  sha256 "00e54d68ed1589507bc511cae29b706740cb2c201819186e62399208b58c0dd1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "50c75417e4c283330702b0dfcc17027a2168626cec9f6da293b91563e8c0d8a3"
    sha256 cellar: :any,                 arm64_monterey: "c3e50a0760ac513253700018cf63bbb6892f761968258d3ba0ab89dd3933b55c"
    sha256 cellar: :any,                 arm64_big_sur:  "41cabd5a302cc788cac2f8765290d3a1313cf180cf33200290077378b56e40e3"
    sha256 cellar: :any,                 ventura:        "268e488642ed6495ba163d51328e495f386dbbde85435bf4f2ec9f9575849004"
    sha256 cellar: :any,                 monterey:       "81f8efe9cc027aa3407132e7dd08413b12667baa2abf8f00876b605a8d450991"
    sha256 cellar: :any,                 big_sur:        "ae8f28d9fcdc6b4193f997e5c9136905d4d7e498ac4c1c36405dc3bb62737396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fba017ae14f8b5339e4f0ecef680f5acfc3457d4b2df2f9884c1d592b698e84"
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