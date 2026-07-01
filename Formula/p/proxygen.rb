class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.06.29.00/proxygen-v2026.06.29.00.tar.gz"
  sha256 "76098669765a9b615b3e0d56bd7b71eaf732ea5a75fbdd746d588d444b517141"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6d8a717ef070ed7d9a896365a3381aadfece1980fc2c0d299d5970320827d8ab"
    sha256 cellar: :any, arm64_sequoia: "73c69cd90833da0d1478ad51cef908c6b25e163816ab16156512c43babf26810"
    sha256 cellar: :any, arm64_sonoma:  "109dd5aaa82ec0f1d7eeda0a99eec42eb7a88cb79c6c79d11879fb94a5f6bcb5"
    sha256 cellar: :any, sonoma:        "da065dd20debfd968d36f5d4c5c919ea0b0a28ce6a56e081becd35e6515abd7d"
    sha256 cellar: :any, arm64_linux:   "b42ae670bd0222a9901b7d5c5cce61dc694f8946411a56ee550d77f4c115b34f"
    sha256 cellar: :any, x86_64_linux:  "744353911ecb38068a408570585918ff4beba4d61167cd2ccd09c1d5d9a97463"
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