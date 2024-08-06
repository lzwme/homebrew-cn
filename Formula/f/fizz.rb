class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.07.29.00fizz-v2024.07.29.00.tar.gz"
  sha256 "df637a78716f77f4d40df87cfaac277501053cefd25ec838c863ce8ec9fec20f"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c2621d5751d9dd75dcb090a15b804171059b4e891a0fc134108593dd4fa9b9f9"
    sha256 cellar: :any,                 arm64_ventura:  "1795aa6bc26b2f39ea12d3e5af28c0b2966963eecff69d15faf48cb7017b54f9"
    sha256 cellar: :any,                 arm64_monterey: "f3770c8f8b3a6a8f849df9db79d7f42b98e401aeee3de7484e1c75c7a25f5170"
    sha256 cellar: :any,                 sonoma:         "ebabb1491661800653812015f95857c680552690eb6ebd20acf6f47dcb2c8058"
    sha256 cellar: :any,                 ventura:        "d97744e3607d74c6e04a3553280e08e4535d50252dc6fde19ebf6dd627e49ba8"
    sha256 cellar: :any,                 monterey:       "9d858a42d25fc565dac0c302d0bc5170348eb3a19081d6060a0addaaa3230e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01767bd74fd3aee9ccacb9486de1dc956d890b7f151bd4ea20ac340b82036832"
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