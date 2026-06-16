class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.06.15.00/proxygen-v2026.06.15.00.tar.gz"
  sha256 "80f941c46c0c509bd14655d1745fb4cf1c92753e975cd0aa71aff84f86a4f1b3"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d29e589c25866f98a7c0e05544c09396d0162750201159cd02f47b5442901ddd"
    sha256 cellar: :any, arm64_sequoia: "3883a65c1b8a6b39eb7d9e2fa54d42a04432212fa4a4640aab625b552d827886"
    sha256 cellar: :any, arm64_sonoma:  "1d478ef7de4cb5b954b8485593dae98dc5af6d995a5db7cdf14bd3315939bbc1"
    sha256 cellar: :any, sonoma:        "5f44aa1b59ddd16cf8f385a04519aac4691ce1eb019709e9001c9d3d81d33a31"
    sha256 cellar: :any, arm64_linux:   "b9c34dc253470cc2ef3ba80b201f80f8fd95799c59cb94bf9e00fd5de6842751"
    sha256 cellar: :any, x86_64_linux:  "0eb9dc5ea11d5bdc8471c4eb448d799e8469aff989ef4eb5cc2f91ac107a55e6"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "hq", because: "both install `hq` binaries"

  def install
    # FIXME: shared libraries are currently broken
    # Issue ref: https://github.com/facebook/proxygen/issues/599
    args = ["-DBUILD_SHARED_LIBS=OFF", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
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