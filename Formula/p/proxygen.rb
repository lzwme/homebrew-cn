class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.07.29.00proxygen-v2024.07.29.00.tar.gz"
  sha256 "3b46bfd722862c46488e5206c05550d92ccea76ba5b334a3e714579dd8503f4e"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a02f6597748d77828433966daf980a20ed710c768256cc18d3895a1665c9bc6b"
    sha256 cellar: :any,                 arm64_ventura:  "164fe4ba7a43a3ea150b59e79762467f358fd87228d7be4d2223bf2587527eaf"
    sha256 cellar: :any,                 arm64_monterey: "401eb8e465b7ecd531fe653fce4d93918d3c71ede49b6689424a1d742317e32b"
    sha256 cellar: :any,                 sonoma:         "472b50d7a6704effb731adf24cf11163e094eaf923d36f5c8d190a079748b5fc"
    sha256 cellar: :any,                 ventura:        "a9059296a68780550a4c3d0e0165380555165c23625ba8b6d8488460b152e18e"
    sha256 cellar: :any,                 monterey:       "3be63b36d16a84bf4b57123a04d445f8d9b3ae6c0542ab66121c2f9d0f32c652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f93c9b68ae6d9a7b589b95c3f4433201ce1d6bf4cabe44836c8a938284e714d"
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
    pid = spawn bin"proxygen_echo"
    sleep 10
    system "curl", "-v", "http:localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end