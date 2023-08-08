class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghproxy.com/https://github.com/facebook/proxygen/releases/download/v2023.08.07.00/proxygen-v2023.08.07.00.tar.gz"
  sha256 "7931d8cfe93642860d4273adb89d533dd26643756a77a04a76496e4e9de1eba3"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ab965692cf8825a162f849e4a0577033dfb362dc57727d59fd83ff1fcac3bbde"
    sha256 cellar: :any,                 arm64_monterey: "5a2d30369d8ea8824466c934e113b8649613cbf7c035ffdd272748d757ab6826"
    sha256 cellar: :any,                 arm64_big_sur:  "1b588d071db5ed70ea068379d9ad1a7aa1bffd100a1254c07b9501bb3c5445a0"
    sha256 cellar: :any,                 ventura:        "774790c68f0222bf5452336b64b7e1641f5e60d2c0c83fc8d26444ced7127995"
    sha256 cellar: :any,                 monterey:       "b3d5f916a42d65297c0c0b7bfb8ff644fa87e508799d1d6dc24f46313fcb203c"
    sha256 cellar: :any,                 big_sur:        "cbd4fba1f4278fdb016d9d1e134db90d2993cb99c83061d3c632d3a4e4288ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "266cfdd57c8e729e151fe97c996060900a0bce95e1df7b0cac4c135df7d8c3cd"
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