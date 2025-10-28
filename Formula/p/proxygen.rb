class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.10.27.00/proxygen-v2025.10.27.00.tar.gz"
  sha256 "250f21c36464b8a0c4bab5825540cdb40a000e2902d4c2e19c1e1a20fcbab946"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "d78d065aca9e0011757dba8df6daa0270f64ff836b47f5759c5535cddafdc890"
    sha256                               arm64_sequoia: "3b1a86b8432b51dfa83aa5768a06136cb2a1bbb40c90103dabd7943609b548cc"
    sha256                               arm64_sonoma:  "14ee8a9c7db01f0b195c326c024a917b85c132572e53a9c5523262d22176b435"
    sha256 cellar: :any,                 sonoma:        "8c686c9f1b2ba4619078caf3058afe52b1962d4e18183c92561bc00be420485e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "079c34e43a191fa7d1bcc7fa9853f0645560206d4bb669cdce622fa419c78076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c2cadcca24b7d6e1dba4758c951aa96af7217e7200cb1fba6d0ba11e1c0401a"
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