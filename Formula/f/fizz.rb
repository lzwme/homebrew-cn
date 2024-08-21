class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https:github.comfacebookincubatorfizz"
  url "https:github.comfacebookincubatorfizzreleasesdownloadv2024.08.19.00fizz-v2024.08.19.00.tar.gz"
  sha256 "b4109dc353ddf99369e8866eac3c0d78e451ec3cd9ff4edf1faa8293480c9328"
  license "BSD-3-Clause"
  head "https:github.comfacebookincubatorfizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1347008eacccb5a27b2bea517a06c9ac792afc8faed100fbe8ff074230134b7c"
    sha256 cellar: :any,                 arm64_ventura:  "55711df3a69c1b63b2cf677161c06382898df61e18c74a06570de4b1d5760bf8"
    sha256 cellar: :any,                 arm64_monterey: "36cde90aef9fd037c30d22743b23a5ade2048997dbf3919c2701f9be788acaa9"
    sha256 cellar: :any,                 sonoma:         "f7ae98b13152c8e238947d1e888c990712d92c6d32d46a436a43f0e7738fda07"
    sha256 cellar: :any,                 ventura:        "9d9919456927d043351403e9094bde7bb3ffc8deba645ff3bf8ebb022a9f8616"
    sha256 cellar: :any,                 monterey:       "41be660423e3e841af92783b2c40e3daf07c931c84dd8b05eca869158ce2003f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e2a910b9f00e10cfc560d37426482ed3e5ab4f9fea96751958b10b77cd45ad"
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