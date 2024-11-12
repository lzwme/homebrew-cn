class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.11.11.00proxygen-v2024.11.11.00.tar.gz"
  sha256 "7bf41bdaf4e14eb8cfa4d567b136197530677edd61f7a085c97d01292bc564f1"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0e2e04b50b11ccaf42476b841518ec0597d1ff2c2ce40ddf3c5e1c232c8a9ca"
    sha256 cellar: :any,                 arm64_sonoma:  "910e4ed00c3c715bb7c166be4168fb92b9710e7ed629a6ceecabb0d15a9ba426"
    sha256 cellar: :any,                 arm64_ventura: "20aa347956c1a8125e19c269937a7b26f9409f5438e8851fbe384fdc8d6ae3b8"
    sha256 cellar: :any,                 sonoma:        "9d6d8f365a48538ccbedcaa22012033a3a669eadf78274f604d4c3dda2a28e86"
    sha256 cellar: :any,                 ventura:       "42b26077abb147da68a1f0438fed748bc249987f2e6f1853ea25e836c5c20496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4100ca5c8f157977111da74b73a9d27dca5e90eb07116919ae093e97a96d7094"
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