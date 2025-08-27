class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.08.25.00/proxygen-v2025.08.25.00.tar.gz"
  sha256 "e7397cbe93bb8567438f033bc5b1e407b074061c72783d3f55388e416b63fcf0"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "65dd297ab4f4276a87018d205cead9359eea2e58246577b78442b97c09ac49f1"
    sha256                               arm64_sonoma:  "bc7699a34533dddf5267a488f0021683be288b35531bc963bdf1566fde758df2"
    sha256                               arm64_ventura: "a362774ae89aa065826d2ab8b5bcfcaa8e536d7616b307ae877aaa1a29007d76"
    sha256 cellar: :any,                 sonoma:        "4fa681f6f3fc0807dcf4cae86532c5e6ccaf695d2cfd781030856622b3beb3af"
    sha256 cellar: :any,                 ventura:       "b2eeed9472fdeaafbf2e066e4557acfd2be63a0e9c4e5f45338d0fd47e31d21b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d0339c7df3078e2cc530108ac6be12d70b1155dfbd9e86f9f91b3ca684a0204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73ccd14d4d877f373255226da898596d4169cc66775ed66c44e6bbd31ac0104e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "c-ares"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  # Fix build with Boost 1.89.0, pr ref: https://github.com/facebook/proxygen/pull/570
  patch do
    url "https://github.com/facebook/proxygen/commit/10af948d7ff29bc8601e83127a9d9ab1c441fc58.patch?full_index=1"
    sha256 "161937c94727ab34976d5f2f602e6b7fcaecc7c86236ce0f6cbd809a5f852379"
  end

  # Fix various symbol resolution errors.
  # https://github.com/facebook/proxygen/pull/572
  patch do
    url "https://github.com/facebook/proxygen/commit/7ad708b2206e4400240af5fd08e429b1b0cbedb3.patch?full_index=1"
    sha256 "4e64f687017888af90c4c6e691923db75c1e067fc8b722b038d05ee67707767c"
  end

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    port = free_port
    pid = spawn(bin/"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end