class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.09.25.00/fizz-v2023.09.25.00.tar.gz"
  sha256 "002949ec9e57e2b205e43a7ca4e2acd8730923ad124dba8ecbe4c0dc44e4627b"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b7f7bdb2453b33bc4f491a54c5306fd3d06c6303c0823a0ab93f0dd228cb8eeb"
    sha256 cellar: :any,                 arm64_ventura:  "6c49be3a8c2499b6ede5e7f78dea05ff78ea7696db82729fce79d59ed48a8449"
    sha256 cellar: :any,                 arm64_monterey: "e1b8aff7402580c7d65885d1ccc8ee71c65e536d0cd6358b2a3fadfffa5191d4"
    sha256 cellar: :any,                 sonoma:         "137a88a26548073ea0721a6ab805591915ef1f99f94c337045d648ed5e281791"
    sha256 cellar: :any,                 ventura:        "bfc724de16d960053496fc0f430b2b3ab0d844a57710c6185764f1edd10ff81a"
    sha256 cellar: :any,                 monterey:       "f4cf3b0736cfd7f17048713ccee161f2a3b374d2a62ebf7b38137b4f78ae9f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d831d3b1d27118a4e078e791cda032b85d5c6e8cb9ff24778450967572c87962"
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