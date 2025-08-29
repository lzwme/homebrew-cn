class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.08.25.00/proxygen-v2025.08.25.00.tar.gz"
  sha256 "e7397cbe93bb8567438f033bc5b1e407b074061c72783d3f55388e416b63fcf0"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    rebuild 1
    sha256                               arm64_sequoia: "6bb39c37508260f20776ded6d8542b966dcc57855f067aa0bab6da8a425fcef7"
    sha256                               arm64_sonoma:  "19cbde3ce930b7a9150a87cfbd67bb73fb6320436d5466d7d5762a525b386ad3"
    sha256                               arm64_ventura: "6d525af161582983242795d367b32f0cbc1d8edaad4632a6a09e64c426b09d41"
    sha256 cellar: :any,                 sonoma:        "5c5694ffc6401602394ab1227231cd38071f6c545a41e3933659da51988a9e3a"
    sha256 cellar: :any,                 ventura:       "bf12c14c6124f089c6b6821803e7a61ab9e697acb475e68d5e6472d4e3882cab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0cb2b7dcdbb48a2d49b034f6b4ef5750cd0b57dfcb9370ca3b1efd4b77e8ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ddf97e3cbb525994f69c0cbd4e530dedc266b819d4438ab092e01ac13f2404"
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

  # Fix name of `liblibhttperf2`.
  # https://github.com/facebook/proxygen/pull/574
  patch do
    url "https://github.com/facebook/proxygen/commit/415ed3320f3d110f1d8c6846ca0582a4db7d225a.patch?full_index=1"
    sha256 "4ea28c2f87732526afad0f2b2b66be330ad3d4fc18d0f20eb5e1242b557a6fcf"
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