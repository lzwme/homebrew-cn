class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.08.19.00fizz-v2024.08.19.00.tar.gz"
  sha256 "b4109dc353ddf99369e8866eac3c0d78e451ec3cd9ff4edf1faa8293480c9328"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f54e8027c38a4fbd079629d1f65a3b3bcf2c118dba648523f70cd6a5acfa64ea"
    sha256 cellar: :any,                 arm64_ventura:  "e198d8f9352b0c0001f5950dead9927b830184ecbd42d37f68d89232b394bcbe"
    sha256 cellar: :any,                 arm64_monterey: "cc6b0c7109cfac31afb302cb833bb937fffced117b8456e92da8764be0c555ca"
    sha256 cellar: :any,                 sonoma:         "101a8ec477b1d6ed9d58dcab7dc5716d5901927489144c12ad58d76753835926"
    sha256 cellar: :any,                 ventura:        "38494d90ac41506c1cf9d5504b04e8390ce836b741b50aba5d648fbbee3a8df9"
    sha256 cellar: :any,                 monterey:       "48311427dadf7e9e102320849caebc9da0519d1af2fd6230d2506be5e88264af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ee9ad85f2040a537cfef5a1efaa55bc74a87a8ead603505d8aa189f788eb6b2"
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