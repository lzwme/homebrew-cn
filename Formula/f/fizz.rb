class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.06.17.00fizz-v2024.06.17.00.tar.gz"
  sha256 "c3cdcbd0c15417d2a0d4000836e85e0f72dca188222ab04fa79a7919f2037525"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2fbf63658f5b90e0bb41a60fbc4cc0361ba8d0feb3e6f3670856e1d92271f42c"
    sha256 cellar: :any,                 arm64_ventura:  "aad844d4d4ddb950f6308d8fcae5ffe0e8ff2438f306b4da4201cc3f3b958db1"
    sha256 cellar: :any,                 arm64_monterey: "7c4d31a0718b37c03734546420bffd237f9e6fe670ce116572a0653926133e47"
    sha256 cellar: :any,                 sonoma:         "a86c57efdb9ecbe1107d4b0beb04b4f3ac42c81d9f81607c2b4d8b4b560de4cb"
    sha256 cellar: :any,                 ventura:        "1c30fbb038515ab1aca7a61404cfe77e84a40615085bbfc0c9acd9d36ce7ceaa"
    sha256 cellar: :any,                 monterey:       "bc7fb29e3cacafb4cd180e0863ba5a5b0112eaf3c6f5b746a0d89eaaf06918e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1a334652b438792aa56d961f234a3446e63cfdd00ed93d09c92e5d31d4cac9b"
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