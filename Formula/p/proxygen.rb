class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.08.12.00proxygen-v2024.08.12.00.tar.gz"
  sha256 "b8d764fd509ab1a3c9d4dfdc4d0828576b84dc4b2252483846a62f9852d85d4c"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "69a31f6e22cef786f2ddc1ac5e210cf14d5379c29ec3e7dd07ee855d33c94b4f"
    sha256 cellar: :any,                 arm64_ventura:  "10c55ea345ff9d6d3642f0c770e0651ac8206417a89992ed139b6643f6fffc0f"
    sha256 cellar: :any,                 arm64_monterey: "db0b5786660f42cb51915d76f0c115f7f6dcafad43751ba0ae4a528fde2f007d"
    sha256 cellar: :any,                 sonoma:         "555f849f89d1c9351a42aeca1dc5cdb1d6def523fae2e9adb2b3856248d1bacc"
    sha256 cellar: :any,                 ventura:        "1b85155ed160eeac64c8875dc49b2a3cd93e87505ebeb0c7143e5203cb8e9536"
    sha256 cellar: :any,                 monterey:       "a5ee9bf2d95dc8df19f2eef13ba3ec86f865fcb0653a675fdd4ce1c2d13f14f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbead113673c1fcd1aaa6da72115f5430870c0da8a7a2f4557cec3bf28152a78"
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