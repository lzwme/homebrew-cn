class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.08.26.00proxygen-v2024.08.26.00.tar.gz"
  sha256 "2649561465d968e3ca7a7bd4daf3873aded95f2924c382d42fe2c22ec442c477"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d1785192a727c0b6de824cc640edbe3c1b079a69caa270663daa6da2b8e488d6"
    sha256 cellar: :any,                 arm64_ventura:  "81dcfdb7c7ac0e4217ef6d73bb852c70aaa7e132543adf2b2b5aff1957e7ce11"
    sha256 cellar: :any,                 arm64_monterey: "7a462987951aacbf6a575a54bccec97900ab5cb4453ba7f16975c6859408e544"
    sha256 cellar: :any,                 sonoma:         "d4f50463e0090c486567454fa545ab665fc2ce856ea5f4132837139f4d35fa64"
    sha256 cellar: :any,                 ventura:        "e4dc899b3288a9cad73e3e7ab0f0a1f88b09437dded40af3434613ec83a23ba2"
    sha256 cellar: :any,                 monterey:       "ed414d0b36e6d7dc3ecfe991890a84b37eeaa3beee7ca852cdbcb298418b826c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb28f41585e016fe1b53a9239252ec932fb2e426a301b341e0a3dcc9c48c5fa"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    port = free_port
    pid = spawn(bin"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    system "curl", "-v", "http:localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end