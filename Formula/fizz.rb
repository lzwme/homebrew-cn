class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.04.10.00/fizz-v2023.04.10.00.tar.gz"
  sha256 "04052742ed94e216704114cff90f92b36f181705ea2bdecb4c34e15eee230895"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f3d1c7f4d032dabc1070d4c5bdbc5c44519a64439c576c4fb1a9d59c83850c89"
    sha256 cellar: :any,                 arm64_monterey: "1a935d813048f011d1e281823898ce7090eaa5f62ed1a3fd301add2f47ca0644"
    sha256 cellar: :any,                 arm64_big_sur:  "a44f7a7042e854741fdedc212706ae3d845775fa996616726c18b259e25a2ee5"
    sha256 cellar: :any,                 ventura:        "24865ae56810ec096dc1d7d57ce1dd20f3a2c4f9f71f75d476e4ad4996f9492e"
    sha256 cellar: :any,                 monterey:       "025fef26ee444f07e02ba90ea7c82668c29ac9027d9d94dc9f3615585156e8b4"
    sha256 cellar: :any,                 big_sur:        "f47663107858fdc89cc31247c3b1ed4178a30aacf4623dd09d49daf897b95b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3a415415c4f7d21685dc40db9b6b9a02fd32308243fc1f5187672bb11f8d4e6"
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