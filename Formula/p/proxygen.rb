class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.05.25.00/proxygen-v2026.05.25.00.tar.gz"
  sha256 "d4ee1dc235b49c797f2aafef426ad9f4c510fb969ba966d052c7ba0320818ba0"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fbace62995ef4ea63e3113c1589de0fecf50ab7bb714c1d2268ba7e3a28b8e54"
    sha256 cellar: :any,                 arm64_sequoia: "3ccb44f1286e0e46779972ee2b57e8b19f197d63b7cdf8d1beb58e0159bc27c7"
    sha256 cellar: :any,                 arm64_sonoma:  "4ab472ff60a3aa0fd80f3328189460ce3cefb8bfb91d4762c6271b6928aa46d7"
    sha256 cellar: :any,                 sonoma:        "bd6686d512b2f4e6ae55d7b76490bfd2a995ca6dea1ba60fbec47c949aa4963c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec84e2e75d13e59e2316fd3f06275780d8fd7ed231f292b030a8b1f18f36a425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f3e4c8408041aeb00a3e5031607efbe6ee81424f40d74c453a791db6a06ab02"
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