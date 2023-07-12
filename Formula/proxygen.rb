class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghproxy.com/https://github.com/facebook/proxygen/releases/download/v2023.07.10.00/proxygen-v2023.07.10.00.tar.gz"
  sha256 "1adabe4b04a3d13d21cf1f4ef999a8926eea9ddbbd6d32e0dd5273d3d5064ad1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "311ee29c9d0709670285f5f589a7da6deaacc8e98da93cb76981c348b0b0e755"
    sha256 cellar: :any,                 arm64_monterey: "2c2d6c2deeb29c3569757ba456bf4bcf2a2112d2ab85954078203898c3c9e3c3"
    sha256 cellar: :any,                 arm64_big_sur:  "c01bc64db3a486c503d5a67378ec471a2b0e22211b7dee595a18ed8a44a161da"
    sha256 cellar: :any,                 ventura:        "3476e5c22aeb687c39f19e56f1d1d7e32d28bcd5bc6c931ee011b968d332ec47"
    sha256 cellar: :any,                 monterey:       "7548667a47f3efb9cab6fab8d81cbe62d2f961590e748c5bc01113b9958d8091"
    sha256 cellar: :any,                 big_sur:        "6026466b43493e497b0c6383e5e8a82b7cc986bd7dbf562d16fc47fd1eaf2ead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f3658ea2316376b4be6222f45a072eaa46cf1e5232aa65fb74cceeb0eb4f8bd"
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