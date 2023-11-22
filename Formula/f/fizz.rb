class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.11.20.00/fizz-v2023.11.20.00.tar.gz"
  sha256 "83ee032f20ce8ae6ce8885ff64de7c4854fc85911b22b5bc7f91cfd4d7e092f5"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bd8bfad6c64f760545845e1d12afef6db5eb2b14119d10ee0d59726a1a252edd"
    sha256 cellar: :any,                 arm64_ventura:  "75c3c43cb85470e4787b37d23d84a6165f331194a17007513efe60e2728da15d"
    sha256 cellar: :any,                 arm64_monterey: "0e5ccc9be8ab19a9766545b216564e1d5337cf28e9bad2a26727fb8b29aba201"
    sha256 cellar: :any,                 sonoma:         "a514a6f0e41b0c0e2c9b811afd58de9336f8718613539da79b1fdee0e36ea0f7"
    sha256 cellar: :any,                 ventura:        "0e58e8f870d25bacbfe42f1a46f6ee6435254ff7130b39a46d993e53312e589c"
    sha256 cellar: :any,                 monterey:       "f730d7a9addb1e9fc463c09415dc8b055ecd6597b9b06fb225694b4081404505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26487a4e1152711a84543e9cf5e88087b15229f6f53dbe918fdcfa25f30e5511"
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