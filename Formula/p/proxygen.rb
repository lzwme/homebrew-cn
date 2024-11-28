class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.11.25.00proxygen-v2024.11.25.00.tar.gz"
  sha256 "015cdf04ec07ea25b5a039fda5a488f3354fa808c91934d2a49faa2fb32d6f49"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "717e58683911367f0e6cdd5466aa95c62060220beb9e7bb40b795a57f6029372"
    sha256 cellar: :any,                 arm64_sonoma:  "296db39909667eb47ac251ce0b0d9054349e3a738e883b5d996a960efffcd4f6"
    sha256 cellar: :any,                 arm64_ventura: "e2d6d38375ecc0f8a40067591e9b7d260d45ca010197e0f72d6f9f38b5ca69c3"
    sha256 cellar: :any,                 sonoma:        "c8c8928004af4dd93d0164d4179ba67d3ce2f07a2740e629cb142125780f292f"
    sha256 cellar: :any,                 ventura:       "874c58960a0ba9a888a3920036b09578d75cdd8754ae44587af5b1913d68fc12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81fb104fbe28937c0b350163ab71c251d027171da57e7ccb59604e66075e92fe"
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