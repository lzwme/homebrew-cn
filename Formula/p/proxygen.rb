class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.09.23.00proxygen-v2024.09.23.00.tar.gz"
  sha256 "cf5e1b4a21abab7992df49d95431298788415485d38b2d37d0d349dc731e414d"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "a111cb150ef354a606612d9cc3fe5e20dc9f45a8e702bffc254554aa0f555a0a"
    sha256 cellar: :any,                 arm64_sonoma:  "e5d548d22d79ea7c4cf0e1d21c530288d5153b571ed190e174cebc9cdfc25a78"
    sha256 cellar: :any,                 arm64_ventura: "98cf5f863599a6cfe898d7701c22a9a65d2a6e2d2e2a38be3a43533947f29eda"
    sha256 cellar: :any,                 sonoma:        "8788ca662033eb4449556f81fe1d26aabf65929bd2fc5f2cb2c188ed82174bce"
    sha256 cellar: :any,                 ventura:       "9bab2e2abd2cf7d0f0f618373eb61e7a21ceba6f9c21153122f274f12b92a47f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f67353a11f982166dcb8fcc044495b49466e6bd7e5dc1444d81addf4abfad3dc"
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