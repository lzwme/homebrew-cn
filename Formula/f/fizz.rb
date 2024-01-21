class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.01.15.00fizz-v2024.01.15.00.tar.gz"
  sha256 "745897b25d81688cf23c9e39d28bd2cbb7d2d2ac3935293ffb6789dc8cf7a64a"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f2a5c849194dbf2d5c30c2b3e7f30177f5091c7d6b75d4d7035157e4eb28ec88"
    sha256 cellar: :any,                 arm64_ventura:  "a03a15e7e669317c30730186f8d20a1b4e8fbe099f1bc599b37b12014a04bb29"
    sha256 cellar: :any,                 arm64_monterey: "9c4a4132cf3489d7bdc68552d91172ebd15ebdd3b1284114ddde238c1d01495a"
    sha256 cellar: :any,                 sonoma:         "706d828f94695063427bca19d7270084d05a6e7e919c14f0aa4fa8ba80876804"
    sha256 cellar: :any,                 ventura:        "1188393b8df96120dba7c5dd1781dd5abbbcd0e43496b8833edab7d9efd9b909"
    sha256 cellar: :any,                 monterey:       "26b1d78b084863fd32bd1003e358da7472f033c35f77f9d055a202ff5aee9270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8268a97770b75d01e372b0278de411e1bf113ee95816ec3ead5408007e31c3b3"
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