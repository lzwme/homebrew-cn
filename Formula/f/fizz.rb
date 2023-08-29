class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.08.28.00/fizz-v2023.08.28.00.tar.gz"
  sha256 "08c1eac0c6bcad626bb2372f36c14cef6d98cb87cb149b43778f5e756b9f973f"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb95b898e95679876e55b0be0c4a6a41f36b31d8a21b376fe7f7bd7ad6200525"
    sha256 cellar: :any,                 arm64_monterey: "cb99030622d15ee9a7e32e125be96eb6d5ada58ec2fc8616f0fc2cd6cf22e827"
    sha256 cellar: :any,                 arm64_big_sur:  "0752b0e6f04053aeb09ca8cfd0031c1f20dbfa78c372ddcce6fc030b2966d044"
    sha256 cellar: :any,                 ventura:        "f9b1bff94be31c6aa57eff3142d46aa46b80ba5c575eb0bf7e975847b2ace2b4"
    sha256 cellar: :any,                 monterey:       "06d2b7dfefa50a4b0c29dac677d7f7aa79db8b274f889567bb09fc2fb2cfafda"
    sha256 cellar: :any,                 big_sur:        "ef8e51cc34aa231176b0a74f840d9ec7bae393fd7eade65d9a7dac0e8753d340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191ac5a5097aba199f7a14baa1a796b42b708459f22ab82ec519a26181c9293b"
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