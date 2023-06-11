class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.06.08.00/fizz-v2023.06.08.00.tar.gz"
  sha256 "f755ce1b117ec55fa029d0215b1e166a24a2323e89e5af39bc7b8d8933c62105"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3cc3b03e10ec27cc567e2646644b35543c60c23c59166a3896867bcaa06a3e8d"
    sha256 cellar: :any,                 arm64_monterey: "4a97ac61f52485ac80a1787a8d698f34894bce548f6c8acdcde4d4388536e1f6"
    sha256 cellar: :any,                 arm64_big_sur:  "a6f040134973c2fe6d9070e60901d6ba488d4cd415ecc4a3cacb56b844b67a63"
    sha256 cellar: :any,                 ventura:        "b97d1dd8406e69c09c620b21bf42ddc5211ea63a60c62d3881cd688605d90525"
    sha256 cellar: :any,                 monterey:       "50905b18f9fe3bc0ed6c181666da3994fa50f5dab9817a00fc24b8de0c9ced99"
    sha256 cellar: :any,                 big_sur:        "d99eb48a4f8aa3b126ba9571cecd680c35653aa95cf8b8bebda04d8e0fa5ec7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc46b0f170242367881f47ea2405cd1a8bcec9d6ab867a26a4ba713646da19f6"
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