class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.09.30.00proxygen-v2024.09.30.00.tar.gz"
  sha256 "ee3241e1d1813cf79a3e63032a4bccbf7e0eb095f629a3d173ef470752776db2"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4de9d764e83b0518ac8f3b4d8782b41ba95eceb456e46b286e71ca4a5e4b65f9"
    sha256 cellar: :any,                 arm64_sonoma:  "d1a2b9585961dadc11d0d350d5ca1ecb418fde412ebb2cbf4f85fe05ccce1d47"
    sha256 cellar: :any,                 arm64_ventura: "458ba0701a786ebb7855361f1711cd09ff987acc2b9916a5e8bfea44cccfc100"
    sha256 cellar: :any,                 sonoma:        "e96f9cee9f30e7939a18521c58cbcc8fbd0c656a6a07718a87bccf060008d186"
    sha256 cellar: :any,                 ventura:       "02fc9419f72bfaf62a988185ca559a45a6141f04329ce1a315a7fa43c0fff839"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba37c581399c6268cd2bd58136631c8ab678c4f0c3bc218bd117bfcd943c76e3"
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