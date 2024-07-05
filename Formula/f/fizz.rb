class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.07.01.00fizz-v2024.07.01.00.tar.gz"
  sha256 "b09992d81865a7418d4bf8be55b1a1833223757d48818c421019f696e1fb4a71"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89d3d41916621e45667c3698b67c5a3b30827b831b03e61e798233ec901abb28"
    sha256 cellar: :any,                 arm64_ventura:  "3158647a478a335751e99bd9105c7c4d44efc62070fae074fefdccb3f48643a9"
    sha256 cellar: :any,                 arm64_monterey: "76d10c37aac056228162b1c2e19fc33350533dc7facbb5890b15b6e77f0b6736"
    sha256 cellar: :any,                 sonoma:         "4789bcd4ba1ffb74a6a527b730d68c8e97e5e90ca94b02c2f88add3f0d72d267"
    sha256 cellar: :any,                 ventura:        "04994ca6be2851aeb6e1111d0bf6652d0a3ca8f8c056460addc973d0e5215fb9"
    sha256 cellar: :any,                 monterey:       "b4b23be85b3d94b21710accad19cd38ecfa25522dea3f90ced3b9daa8f899156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a529de31d3498ba81263e6c053a09bed945b7f5c85552defc2ff15d35b652574"
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