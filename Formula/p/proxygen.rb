class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.04.27.00/proxygen-v2026.04.27.00.tar.gz"
  sha256 "cb791ae69bf915c3d7756160b83f28a1c5b91bc63d5d1977020cdd0a47b9e43a"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "749e3f022b91ff5da67d333edef86bd1b03a1825e41c5899a364af10014bfe80"
    sha256 cellar: :any,                 arm64_sequoia: "fe2ea4a9e4f2313b47fed94cf1c52f0d25e4a3d8876f01ed9c849c992980330b"
    sha256 cellar: :any,                 arm64_sonoma:  "46d16de322cb18e0cb060ac96b84888aa1db1b7f9cc64ef931bee40a023b8749"
    sha256 cellar: :any,                 sonoma:        "647047968c6afd9aaadb8508631d4f6cd5d870f86755bbcf143275fdc493c38b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15be2348f6fa9ee95c885d43f756ac0958a1db6d2570b58803dff41452eb7862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49851c29cb80777c58cdc46aa45d112fa031896556ade830bb66144aef555794"
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