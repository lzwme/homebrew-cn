class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.12.15.00/proxygen-v2025.12.15.00.tar.gz"
  sha256 "81f8fc60133212e8058ef7beb09af056106ef7b24a33fec3a872249ae989b259"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "f8af418487655d7a09d600911c1072182bda3e4e72f41ce2340d79e7d740c577"
    sha256                               arm64_sequoia: "76440f804a823c864009f578c6290e1034b88640808a3cb31df76af901e7adb7"
    sha256                               arm64_sonoma:  "cd80fdc84c9ead85caf335a9a6211a479bd7817924e8bc721026400ee8c23b2d"
    sha256 cellar: :any,                 sonoma:        "cf94d1fa719f573ff73cbe85f34ad59572a8e95ed6ae6014e42418da5541f415"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9b8bc73b8e07d0c10a064985616cb3ef994def44eecb026b052991a5d15035f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51d73940e93b2767a4a3df663e4415fada4bfbd6480d80a593e8c4d1b52a29c"
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