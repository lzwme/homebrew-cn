class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://ghproxy.com/https://github.com/facebookincubator/fizz/releases/download/v2023.11.13.00/fizz-v2023.11.13.00.tar.gz"
  sha256 "89392fc22c2b3574427ad1804c759f14ae121be738b2cc73582e718ff16a4d20"
  license "BSD-3-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "43df6c0ebc2b8c9670e6087aa73f2f803fe1950343e6b07b647bb3023ed4295e"
    sha256 cellar: :any,                 arm64_ventura:  "2e48b5b2a017e6f92da11d52475336436b00f1b37a5e55ab764fb2aedb17fed0"
    sha256 cellar: :any,                 arm64_monterey: "149144240009937067c169e7278b0cecf74136979c3aa2e9cc2b529ea6c42cdb"
    sha256 cellar: :any,                 sonoma:         "d93775e697787bec31fa177ddbb9e73282768deabb5609fb006cede326bb3c40"
    sha256 cellar: :any,                 ventura:        "b2f37e3867528b4d9da78f3f59b4933123215ceac80aa344bc1b2c37edc1ab67"
    sha256 cellar: :any,                 monterey:       "cd185ccc31936d86c4e40194ed499ca9bc8a89c7804fa3193840483c98f476f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077722e10a30973c5d8061578c22dbc083f74387ccff174d213bb25dc6dc5ad3"
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