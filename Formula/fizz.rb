class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.03.27.00/fizz-v2023.03.27.00.tar.gz"
  sha256 "ebd2e6e7c9850d88edaf546cadaa7fdce608e85664a8fbd7e20eee4a63010c95"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7161ec26c9ba1ae15878e98ef9ade1758f6b92f732522fbe57039e47923bbfd5"
    sha256 cellar: :any,                 arm64_monterey: "1249a90be688044e7f44e219e63990fb76ae1a3421553b27d29e493f3465a73c"
    sha256 cellar: :any,                 arm64_big_sur:  "0b66c2a67837875e45d6f76cfe08df39d2285d993d4beae50e4f301d229bc20f"
    sha256 cellar: :any,                 ventura:        "b3d8f9934de1464d377aaed77f6ab0edc61c2b4c2bf9e1e21d3936ef07b84c6a"
    sha256 cellar: :any,                 monterey:       "4c9d7022e83875308e18fdc1940bec90b63d90edb3dbd0277037801c350724d5"
    sha256 cellar: :any,                 big_sur:        "60ee41131e8e805dc5cc07b75b837b4a2be4d6b171f18e6633aaf08ecd2826cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beeba942cf00165dab762022fe09b2a9d6c8471376e85035406bf40367413094"
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