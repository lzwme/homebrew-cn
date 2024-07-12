class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.07.08.00fizz-v2024.07.08.00.tar.gz"
  sha256 "df74e183ad9f18f2332baa8fde4c601eb69b722f33ca1462e0b6c06dbbcbb9b8"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "60c9f5a48ff9b39d91a849b0c1412e6e1ecd515e544a10eaf6f5dd9cafb93e7e"
    sha256 cellar: :any,                 arm64_ventura:  "a2ace17406d33190cce96894067cd95bfbf2a5d2adbdf73de309a05e20937b12"
    sha256 cellar: :any,                 arm64_monterey: "49e98bfb196359fb43e940320ebe290ba9ed9f862beedcd9e1ada36db23fbbd1"
    sha256 cellar: :any,                 sonoma:         "a4b43e8a8718cd89a2d2f486b6aa1d5f2224a7324dd4c9101820f8ce910b5460"
    sha256 cellar: :any,                 ventura:        "8206bd3275c6a8b25f4a494670bfa90d2d306de97e12b6630c3fee28bb72f75a"
    sha256 cellar: :any,                 monterey:       "78c555c856c036b023678baf9c8d3cca0357f6e6f22f317068f9e8d03b7decd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a312626d2e6ff4c098dc0c72a8fff7e51d89dc736f561d7f9e776651d30c00c"
  end

  depends_on "cmake" => :build
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    args = ["-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      # Prevent indirect linkage with boost and snappy.
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end
    system "cmake", "-S", "fizz", "-B", "build", *args, *std_cmake_args
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