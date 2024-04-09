class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.04.08.00proxygen-v2024.04.08.00.tar.gz"
  sha256 "5e2459cd7e65d1ce238f536ac703544ffa3b8d7f41275c0fb782c5f43d182309"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e84e5b9e91e9564cf67acac0d338cdcb4c06bde374902d726dfc73de35ea27e"
    sha256 cellar: :any,                 arm64_ventura:  "4711660ea6a407c3715d1d99840e7d88d310dba30ef3b9c07a0bee0e78663767"
    sha256 cellar: :any,                 arm64_monterey: "8c078e4febcfff8af3a81f0c4a2601ce2278a04ebb008a39b58f4486df14bfd6"
    sha256 cellar: :any,                 sonoma:         "e1f1fd7d11c10de3d00a73313e0d000bb75dcf54232e77af0791e7bfc9714864"
    sha256 cellar: :any,                 ventura:        "28c0680aaf63cd01d0cb0c88fa7b23f79e0d6d63b3913fdca8073008f3109834"
    sha256 cellar: :any,                 monterey:       "f99f18fac3ccb8fe757867af88b27e324bc15a7732c575de2b207f1e09923511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35cb00ca8c1446a506e3d38d5bd9b49f3c74dd21191f44f4dd1a7d8a5ceacf06"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pid = spawn bin"proxygen_echo"
    sleep 10
    system "curl", "-v", "http:localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end