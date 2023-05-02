class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.05.01.00/fizz-v2023.05.01.00.tar.gz"
  sha256 "0128063e242d7c70baed8cc8a3d6c04c677fc189f814f9df8c07649e4c84a567"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "355925694c328eafe72f51185711f76d9e7dfe9fed1497dea0c3c8ae5114a436"
    sha256 cellar: :any,                 arm64_monterey: "fb0aaab6347d08d53db76e73bc6a2f60414b6b6cb90822d22f755d49960255b4"
    sha256 cellar: :any,                 arm64_big_sur:  "965bd713c2fddaf2f9616aedb37b7d8860a0e315942018726c12d6835c6d3aff"
    sha256 cellar: :any,                 ventura:        "9c05c461d7349033509dd7d2cf2f76095718b27eb5b71638d8e3058e7fb85d2a"
    sha256 cellar: :any,                 monterey:       "b7a1dc1303a7b7943a61a031bb5d44c3b054b8e178485b9be4311fcb5fdbe35e"
    sha256 cellar: :any,                 big_sur:        "d08ce0c4a3aa03447046ef0574c74407c742c40db72e45b2803d329ca10dd907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4179cc06cf9fc08f4892cd4905342ea25ba23a7cdf4390dfce945bc623374e3"
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