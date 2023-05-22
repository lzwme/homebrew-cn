class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.05.15.00/fizz-v2023.05.15.00.tar.gz"
  sha256 "468eca89b75b632ae16f06d4f3e3fb50d8ca145cce64d6c48260997df7770114"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "688a99d085133af5377ee65d304af121fc5be3702d87b0580c3d56a128e291a6"
    sha256 cellar: :any,                 arm64_monterey: "72d1ef4fe8183418325c32c5ca189f84a487a8d9723b15620ffba4b284e44be9"
    sha256 cellar: :any,                 arm64_big_sur:  "2257cc1be26cffdb07d0733b85b9c8316ea889e6521de477529a243fd8a87601"
    sha256 cellar: :any,                 ventura:        "34323da3df77865968dd51b9c17b07a750c5e3283da2f5b9d005a70e058d2cdc"
    sha256 cellar: :any,                 monterey:       "a8f1f4923543eb3c5ce4ed40100d8f3bceca6a097f89943d1bfc875632bb1dd3"
    sha256 cellar: :any,                 big_sur:        "52e05e145a3824a013585d2122005641af4c6f75de22f3b61b779acf3da7d278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85dab38a54313ff3115d60b3b1b6d29dee42509003efbe21bb047fcc244927f0"
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