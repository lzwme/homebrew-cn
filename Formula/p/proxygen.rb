class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.04.22.00proxygen-v2024.04.22.00.tar.gz"
  sha256 "450e36f566cac0fbdb6b6c3066fe93d204d544d10b4ace5ab23205ce79d7f2f8"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5eba7a4483589e1b6e9c8e2d006456885a8f9eaf506cc76c981f03cdb1ed5a72"
    sha256 cellar: :any,                 arm64_ventura:  "39aa644852561b40c246da032fce2b1c921e45383a58893f2bacadfc32529b30"
    sha256 cellar: :any,                 arm64_monterey: "40bed2d5d7e6a01627f2be917860cbd00772d05b4e1fd48a76657c8a17f5bb8c"
    sha256 cellar: :any,                 sonoma:         "f072cd1c4861059dae5c72ad156dad2c4c91397cb35b69319a6ce10a27967205"
    sha256 cellar: :any,                 ventura:        "f730f2f8096c97e5320fbf71bc22e3f912920bd5ad72fd4b2487d4cddf2a9c94"
    sha256 cellar: :any,                 monterey:       "fd77137c09626998f7b3e692624b80c81b71de9d819dfae6e75ab169f0cc32ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4735ab640a34a92ba9db66a9817f36fe79432da0e89c2433ce13ed5c800d144e"
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