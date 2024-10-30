class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.10.28.00proxygen-v2024.10.28.00.tar.gz"
  sha256 "60886f454ac761a950a404051cc260b618c59c2c20159901e1f91e4e30443c58"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96d380a0b6199d173319da4836bcf8f885c7aa6277125f7cc7afe32696e76159"
    sha256 cellar: :any,                 arm64_sonoma:  "946f6781de54e8574b2654e50d1364f455d8311b9adb1e391b7fb27b3e49bc77"
    sha256 cellar: :any,                 arm64_ventura: "7e2b9d905426d2baa5a5747fc7c8240d4c0ede4fa5efa731d335e737d1e9ed99"
    sha256 cellar: :any,                 sonoma:        "b8d22ecbf5d7251526eaec5f0dec992957e19b3e13917905f3ad00b2b87b63e0"
    sha256 cellar: :any,                 ventura:       "9ff40fe087436945a297611f787fdfa6b21b3cd3c8675eaad86d14f80740b5c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34bdff24540414f0eadd84f009fab296a68f9fc7f771def941d8b2371697b892"
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
    pid = spawn(bin"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    system "curl", "-v", "http:localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end