class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghproxy.com/https://github.com/facebook/proxygen/releases/download/v2023.07.24.00/proxygen-v2023.07.24.00.tar.gz"
  sha256 "eeb7374f621c2b5028a42d1c34b4e622c61788105f16ba99fd89c50cb03200c7"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cceeed1b81d0bfeef805aa72630f837928ad2beee04f13325b499d63c90403ef"
    sha256 cellar: :any,                 arm64_monterey: "14b3fa9263c20c9a44c220a1c29881959babcee8001931d975acc7db88d38ec6"
    sha256 cellar: :any,                 arm64_big_sur:  "3c766ff4278385b9f77018c492008aca10c6715dc4ec26470fef556ff32ca697"
    sha256 cellar: :any,                 ventura:        "7e51b7a57974fe964ba2ed84290500732949448b6a120451ad121dac7fdfd3dc"
    sha256 cellar: :any,                 monterey:       "8456d4e3993a0d085bacd4a3277795a8aa697f208c5f007410a40322ff8ce10c"
    sha256 cellar: :any,                 big_sur:        "f1fc325b1fda5085ec6e32558a45a9184886e5fade3311affdfb4ef4b66823d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b924aacd0575c1562cf8c1e5d3222b16832ebfbb29453deb8b15d002e004560b"
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