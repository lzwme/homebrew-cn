class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.05.15.00/fizz-v2023.05.15.00.tar.gz"
  sha256 "468eca89b75b632ae16f06d4f3e3fb50d8ca145cce64d6c48260997df7770114"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36788ba57e9953aa6e25b51fb6b7771c335901147f0e211222b6f9a7f743b352"
    sha256 cellar: :any,                 arm64_monterey: "2598cee5a1f5bc0d624ca8e53ad09d0c0bb101b38087d94b23d85bc9d82f0289"
    sha256 cellar: :any,                 arm64_big_sur:  "77f09147d51df683439c21ae523159b8d5d7e1510fbb3e187878b4d70788f7ab"
    sha256 cellar: :any,                 ventura:        "9a356ea46e7a313ea8795bb9e5c7584fe8d10cbc4e770ff050f843771506bec3"
    sha256 cellar: :any,                 monterey:       "88ae1bc7384d02cd363a3f9169dcf236714dea66b15e6577500ef7091b09c677"
    sha256 cellar: :any,                 big_sur:        "37ef1e02597adb9441ee2496d59a3aa56a336b8f05ecef2bc0aeef3797df8e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b0660ef03d8b5d9301df540a96159debd7e67d3cef68d0014e6961022bee169"
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