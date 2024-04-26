class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.04.22.00fizz-v2024.04.22.00.tar.gz"
  sha256 "f69682348387a1973564b0df4330bd86632f87595b0da6a9e0e9d60e145cf3fa"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "693d86d697af19714c853cf907b09809a9b96871060fdb1de179cf1a8c9a03d1"
    sha256 cellar: :any,                 arm64_ventura:  "854bec9901252ead0cc3471736bfae8468a3cbb1ac8b03ea70f78e1c592656ec"
    sha256 cellar: :any,                 arm64_monterey: "3e94bc8b245de148f14cf5565894e6a8e0d450eebfccf030948736fb61db7426"
    sha256 cellar: :any,                 sonoma:         "b058e0be20fb91ddc00073a58eb6edf2488a179a586487df5e8ac68669fde7fe"
    sha256 cellar: :any,                 ventura:        "b5faef16897fc83f878f5d9ced41267b2a0a5bd0a7fd5a993e0172118b75cbeb"
    sha256 cellar: :any,                 monterey:       "a617d09bef2e02443536080686ce5436a6646c78007362a7688026158a99b6b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e8b68005f126e3f14881700d4aa6895f4e06676c6fa5644205e514c85105ad"
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
    (testpath"test.cpp").write <<~EOS
      #include <fizzclientAsyncFizzClient.h>
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
    assert_match "TLS", shell_output(".test")
  end
end