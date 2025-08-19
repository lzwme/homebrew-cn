class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.08.18.00/proxygen-v2025.08.18.00.tar.gz"
  sha256 "01286d48007a578b3b9964e2f065a07f296de50d8ddac2fdc6fe54bb2145fbba"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "fa88f8a4d249437e9bd7213b299ec3492a728d3fb1c9451a7791789e76df04eb"
    sha256                               arm64_sonoma:  "ec1a4f7f0e4f6b16a8be15b4b4777a969e08bde42fc3170d7a3da91f9ae96e17"
    sha256                               arm64_ventura: "aad6a0f38acb601ca37cccb5d1fd3d9e76f9da8d0816b57b5a65aa2bded5e10a"
    sha256 cellar: :any,                 sonoma:        "1f2d75555ac3c6bb644cd4de3b9f83821ba9b1276695a819602ee69fcdfb95b9"
    sha256 cellar: :any,                 ventura:       "707b37f044ec643d1a86e9b3201fbee5a3df34e39a0fdc48b755921f9713ba57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "217c2edfb832bb2b63d5445826e55d502c15fe7d4c874eb4d12f423ec90e03a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "947bbd8191ad9867e0487fb2d24229d1fb385dfd6f9259ddaebff8ef858c1bcb"
  end

  depends_on "cmake" => :build
  depends_on "boost"
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
    url "https://github.com/facebook/proxygen/commit/d69f521bc0c7201ced9326aabe7ba0ca590621bf.patch?full_index=1"
    sha256 "2b51cbce006750d70e6807bb186d4b06f9ec1c40f7109d0f0b8a8910581a39a3"
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