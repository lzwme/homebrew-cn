class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.10.12.00/proxygen-v2026.10.12.00.tar.gz"
  sha256 "45b5630f5b5b18606a1b7ca9f5334180f85d1bcccef705a5baeca4f57ce1e707"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d394b96dfc8d209a793d4c91aed2de76370fb923f909707fbe9f1e523a372b8d"
    sha256 cellar: :any, arm64_tahoe:       "0d351b43f96645b336c497758a21b7405e1f1fb647ba31d3642ad8b21fbb25cc"
    sha256 cellar: :any, arm64_sequoia:     "91ee32d12ce00555a69e1f6ea55da5d916e4c58a79eb3e3910817c03e51528f9"
    sha256 cellar: :any, arm64_linux:       "11169b3fccc75f90cf405e978bdc23f51fa1aac255ca3321f425366438e91c13"
    sha256 cellar: :any, x86_64_linux:      "8cfa9f1bdaa29fb8e1c18bce76bdac0a7540e9795bbe2cb707a3a0bdba73662e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
  depends_on "openssl@4"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "hq", because: "both install `hq` binaries"

  allow_network_access! :test

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
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end