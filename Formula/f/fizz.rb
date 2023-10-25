class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.10.23.00/fizz-v2023.10.23.00.tar.gz"
  sha256 "f7dbbadd546d0c4913af920ebec67f2634395570a0a02a31b95f8bdfa06dc0df"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2fe33d3a11542fe69aed381a939ef63a9a09061fdb8957c06affe64f8fe0504b"
    sha256 cellar: :any,                 arm64_ventura:  "52e3e0f7a98914c4173bedf5a9a515c79a74ed20a306a0e38aec1d59f459a6a9"
    sha256 cellar: :any,                 arm64_monterey: "05c46a128c0823589f7fe02328f19b0913152f6e635da658a3de85dd8abc1f53"
    sha256 cellar: :any,                 sonoma:         "2e1bf6eaac977808b8761bdf83a7ccdf5b2165644c8b5c83af91f7a903a46f4d"
    sha256 cellar: :any,                 ventura:        "ccefe154bb24605b8371d70035bdd9a370a89315bb4ca92a3989c0155ac1534f"
    sha256 cellar: :any,                 monterey:       "d340e3ef67c1c5aab5542e85ed9be638ca4f0178db66991f2a92179dbf3195e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872d608928a0aaaf4f6a7ce2057e866928367c7bbf18b5f34ab6adf645b4af14"
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