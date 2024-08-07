class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.08.05.00fizz-v2024.08.05.00.tar.gz"
  sha256 "fa8e46c9d3dcb3dcc92f6fa835ef41f2a01d2ea89a500ada170890a481f2992a"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "232b75da194b297dce36636a0cfa2b0fe35b1e1758ebf6d0279b793f86e24f9b"
    sha256 cellar: :any,                 arm64_ventura:  "a34fe45f5ed37056aaa70187f7b9d6784b511156dadcfaa0c3266bc576500f29"
    sha256 cellar: :any,                 arm64_monterey: "6c30d9ce3ecc63a4b49d33f6b2ede7a0e4bfe8e05ad7cd8343aebb62485023cf"
    sha256 cellar: :any,                 sonoma:         "6972b70af38ac77bdef7d9af1640473a475a598b9d86cb3e450b0ff99a56c651"
    sha256 cellar: :any,                 ventura:        "f0b251d78616360fa88be535446a51e8602f0eadb366dba3d2e14f7de137d00a"
    sha256 cellar: :any,                 monterey:       "ba5f7506a04effeb90975f45a4a93581d68ce8f0ee58260170068fede3da67b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee4ff6181ce0fb46af8293caf051b75920baa6c19c1d5c32f7ff5876103d5f2a"
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