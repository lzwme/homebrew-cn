class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.07.17.00/fizz-v2023.07.17.00.tar.gz"
  sha256 "e7325d076a4717999ded84fdb2745de5d68e3c5f1990333afe58e0b83a8f6385"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e6cb14a8bc05b70c12a25a0b26c09efdb3105a6002ad5c989295b55e276d73d6"
    sha256 cellar: :any,                 arm64_monterey: "b0ce7d093c8d24e01c83d5da2cdd4f7b32ef369ba2f8ad5a1a10b5f68ddcc925"
    sha256 cellar: :any,                 arm64_big_sur:  "7da2e745999d0fe0a17a802773ce7c9668bbde77518e681949aaa20d1999547a"
    sha256 cellar: :any,                 ventura:        "30c68a2cb7fca387bf4cfc66fcb1fb872cf46e4add469763ffa74b78f8b32543"
    sha256 cellar: :any,                 monterey:       "6fdbf3f8efcce6d580407c2430d6d3fd401510b5025bb24a4d4b026d0744c290"
    sha256 cellar: :any,                 big_sur:        "0d006e9cef2d4ed8e50f5d5451655be67da6bdaec544461b7a6bf2204521def6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08fc0436828308de38e0d509101f2d05b1f65f5f585333f5131be65bd837caae"
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