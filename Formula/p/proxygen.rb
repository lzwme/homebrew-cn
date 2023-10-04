class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghproxy.com/https://github.com/facebook/proxygen/releases/download/v2023.09.04.00/proxygen-v2023.09.04.00.tar.gz"
  sha256 "e4db076db908b003a23ac139b6c433d8c34daa77cbdea33fd5a77bf9889dcdb2"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "547c90eb0e3f74f1797aeee1c4525eef7a0902b8db2d256265ce6c6c7b386362"
    sha256 cellar: :any,                 arm64_ventura:  "77b30f1f5082f58a11b43bec50923b3212c599a78b1eda53d363309979150127"
    sha256 cellar: :any,                 arm64_monterey: "7e84ec72f2e402a5d2a3d763dc986b6d6203b0985cb4964fe1a38480f65bf388"
    sha256 cellar: :any,                 ventura:        "804ffb87e49c1a04e961c01e7d1904216caf052afde8d865896df175f496ef8d"
    sha256 cellar: :any,                 monterey:       "a90277dc3a784955956f83b1671eecf9489c4f7c55c21d5a031ae650fb0ba552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47e044a23ca3f0b538329d6f3ea96271c9ebc013dd61be075b1d56dfcccf5a95"
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