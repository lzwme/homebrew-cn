class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.08.26.00fizz-v2024.08.26.00.tar.gz"
  sha256 "551523d0630c51f9df38c1e3029403299aad2540bf06b78fda69ccae56db6d5d"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0f52eba4f97e406e2231b34b6a58c4922f268631516dbf398207f7d06f64d25d"
    sha256 cellar: :any,                 arm64_ventura:  "26ff3399f763c5f2fd2164c5929a2c92740c2d03888a8bedbc581e8cc31fe38f"
    sha256 cellar: :any,                 arm64_monterey: "2a591434cd173e4e2646d03ed223605adf02d8867fdb7cec1c52cff039af238f"
    sha256 cellar: :any,                 sonoma:         "f2e28b2c555d8cfda81b5a9f1ff14bf4b760f90242e44e49a7534d918ff562b4"
    sha256 cellar: :any,                 ventura:        "73e876df8180ef13a82529d7717e649f87ae3225a75b93ea4779f8becedf2f18"
    sha256 cellar: :any,                 monterey:       "927d0c142021f64a36a77ab88a51968ca33ed52c5c324ea3871c63a8ea94e33f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fc65bef2eb7b0664cd191a30c010923efc6442a5e8da670684f93444422fad0"
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