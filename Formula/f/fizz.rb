class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.04.08.00fizz-v2024.04.08.00.tar.gz"
  sha256 "a4ae7c52dc5913257546ec8737c8ce05e72350c255ce7fedfff387186712c36b"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "68606bde2cdb6674598c36d6f1db17d7121562a011dc176258dd3387657ca28e"
    sha256 cellar: :any,                 arm64_ventura:  "0509d296566ccd80e47c1c5137dcbe8cc861a63f83aecef2d29bf676b517ca26"
    sha256 cellar: :any,                 arm64_monterey: "ab8fcf21654232a9d9b041bd1f074a9e7bbaeebb50c7e5f5e7ac71696d3b2caa"
    sha256 cellar: :any,                 sonoma:         "5bf25e3d4762f392d63c8ff2b88b5a0a90857e3c4374457d479203040de6eb61"
    sha256 cellar: :any,                 ventura:        "c88687a41d746cb00d68a7950f428f394cb16bb8c40a4da2d9c931c103c92d18"
    sha256 cellar: :any,                 monterey:       "849d5ecf7112b63a1bda657fb1ebdba8dd83326f69be11f55963b163f675fde2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8e8f20800700c42b6f1f40401ebc9dd4e4ff2fc120e0478c140435cb091dc0c"
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
    (testpath"test.cpp").write <<~EOS
      #include <fizzclientAsyncFizzClient.h>
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
    assert_match "TLS", shell_output(".test")
  end
end