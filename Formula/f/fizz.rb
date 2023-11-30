class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.11.27.00/fizz-v2023.11.27.00.tar.gz"
  sha256 "3ec6e306f3348ec9f7b2cf2056c2398a6c3f79429c2c9d957e2c09e618017a26"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5269cbfef6bf0328bc15d4f6ddd0376cddf0c09f00aef5a6eb100c733e4a94bb"
    sha256 cellar: :any,                 arm64_ventura:  "6bdaff5d8272dd494bd791a5073088544439a8d1bc7f5c803dae25f4350d58a8"
    sha256 cellar: :any,                 arm64_monterey: "8b14d925a75772dfb443e54fc1445117c4df4a1dd9d2da836e37e4dce8ad4fc8"
    sha256 cellar: :any,                 sonoma:         "0dbbc0546b80213ac9e67bfeea4901ce6ce3c9743585f5c337a83a56aea4cc8d"
    sha256 cellar: :any,                 ventura:        "8aa78840a6372f6a1d648ede10eb2ebb2ff16df14eabdcf7242123dc83ca54aa"
    sha256 cellar: :any,                 monterey:       "933f8f8179f681bdc3fcce02637fadadfd34cce119af4b1ef79226c8a4a7d711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c133fc5e53a77e0d7ed39cf2ce8d221f5fe911e7ecae4e008731a0fb3f80ed8"
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