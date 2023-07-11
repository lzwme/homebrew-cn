class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.07.10.00/fizz-v2023.07.10.00.tar.gz"
  sha256 "00e54d68ed1589507bc511cae29b706740cb2c201819186e62399208b58c0dd1"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dfe7e7b76695aa88466db729e7d9cc78dddc373bc2723f286fc88020cadbc2ee"
    sha256 cellar: :any,                 arm64_monterey: "8a71eb99786b5c71af0374c5075508e6e4262d550655281ffe4c433e4c4ee11c"
    sha256 cellar: :any,                 arm64_big_sur:  "e4869701b84b14e7bee3b9f2fb9fcda9d10e93d34ef16fce7ef9ed7bccdda237"
    sha256 cellar: :any,                 ventura:        "65790cf24cd371f9bbf60cadf613ef6e4ad2fcfd2c4b71b78796cb33b645ae9f"
    sha256 cellar: :any,                 monterey:       "ee95562ae28d6403739e7346708e61dc1a28971fa8a0b2a701c467c37af233ae"
    sha256 cellar: :any,                 big_sur:        "0be272337a660982ae5db6bceb9c7db4df26c582c561273d2c6040a813575221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39854faf6af36a148629ad85c1e5b3f2cbeda2c015900f892730d446e679aea0"
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