class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.11.10.00/proxygen-v2025.11.10.00.tar.gz"
  sha256 "f0c43c542d0db9ec83523394309b06ec9f054fbc886408fce473ba9c8d1ea819"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "e946cb704d33dea138bca8e658c63b5643251eabcfad34e3f22d24dd747d8b17"
    sha256                               arm64_sequoia: "729c370a53f4619aa2657c3c8cece87af600a990bf8b54c5473b480469931d69"
    sha256                               arm64_sonoma:  "ab12e89dbf7d9dcf6667e5c95525b4f7f0cc06fbd63863b74e2eca4ffd0e0b8c"
    sha256 cellar: :any,                 sonoma:        "4b25bcd2e3976bf0c92f07d4032ef7eafa96a176935f86a380d02a356f2f2ab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37e62f229a85e1e23ac07eca76f5809284a98aa2684d641e283153298f2a64d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bec71ea9cf735621c8847784a14d6a9cfbfa8c2238b6b19197a258a30c53e276"
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