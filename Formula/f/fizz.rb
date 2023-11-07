class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.11.06.00/fizz-v2023.11.06.00.tar.gz"
  sha256 "183a82386ce2ad361a56195f1f1a19e21fe9a74c4a91351361ba2c468a8076b6"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5517906e2bd5d9c9d1da47ecb28c7fe60f80f55b33f1611a7f5729b98c8dce0e"
    sha256 cellar: :any,                 arm64_ventura:  "dcd6f0c76286671d6b31e8ec9e68c790d629e7ed5ab2d7ea56ec75330b2a58be"
    sha256 cellar: :any,                 arm64_monterey: "19eff697040126f933f1ae0b1e3e976e41c96acbf424d7daa71d510f35f4d453"
    sha256 cellar: :any,                 sonoma:         "02af2ee4c6abc72bc6ebb415e28b831e494b2352fdff2be180d1d7503b34f672"
    sha256 cellar: :any,                 ventura:        "e60c73ebaf3e1d3a62188cc3588d45d21f2f9b3ad822f9247e48368a31c988f0"
    sha256 cellar: :any,                 monterey:       "37a8ef5bf84f7d3e5f248f1426864af0cfe94226309f7c08bcb2c9b540b9aea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc582e28a70d04603408ff403ac9816872b1b3ab0d780361b5fc1eea2cbb35c4"
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