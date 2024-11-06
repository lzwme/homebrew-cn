class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.11.04.00proxygen-v2024.11.04.00.tar.gz"
  sha256 "c0084f81e0189772b0bf03537ef8d32ed106da8c45ef16150010df038223c1b6"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cc0a14404c01206b8c6bddddfc0c4b32c1015bad672b647da4f2e8e912ebeae3"
    sha256 cellar: :any,                 arm64_sonoma:  "7c542b351c97f29342c26cbe5dc87126d04c329c13578c8e830b7c1ee7b5ae6c"
    sha256 cellar: :any,                 arm64_ventura: "c75e81aa8c796b87b03fc4832f71c0a4f7298362366c2596151d3a94ca0b0731"
    sha256 cellar: :any,                 sonoma:        "879504c3c32e2525673bf9a0e023a709103c41e70369e2cb80cce7144701cebc"
    sha256 cellar: :any,                 ventura:       "5e08eb9688f0dd9457d681eed18de251939accd06517fbe7a549eb29723fc4b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ceb0b85743fd3ec51fc765f6ee8b87a23a1c06aaeed1a965e45fd62d6a9eec"
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