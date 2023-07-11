class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghproxy.com/https://github.com/facebook/proxygen/releases/download/v2023.07.10.00/proxygen-v2023.07.10.00.tar.gz"
  sha256 "1adabe4b04a3d13d21cf1f4ef999a8926eea9ddbbd6d32e0dd5273d3d5064ad1"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d98f9c74a43410f047b7111e09a7a796655582c874ebb469add62d1b3f29086b"
    sha256 cellar: :any,                 arm64_monterey: "a6a84306f9225942066f12e1a2a446859615a5ef34a005de38ef323be06c89ed"
    sha256 cellar: :any,                 arm64_big_sur:  "4f74ee8603495e221cb99d194248556562d9bd8c4c389f46a75e95ee6b209738"
    sha256 cellar: :any,                 ventura:        "887f8d3f9e8b0875cb4c9683e9d7af3edf47c74cc8b2e5e294d49f789f4445ac"
    sha256 cellar: :any,                 monterey:       "8658f3a552302a0cb05ddfe014364b2db9353bc49a6daa95fd7cc5885aac37dd"
    sha256 cellar: :any,                 big_sur:        "e2146aa3f88344ce248491cc73f995b87f659ba6c565a50a9405fd1705ac6e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d58fc28bd48d9a5ba2d0bb4c1fdfaca9d0ecd212a4280189091ddcd8e38ecdee"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
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
    pid = spawn bin/"proxygen_echo"
    sleep 5
    system "curl", "-v", "http://localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end