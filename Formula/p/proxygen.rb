class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.10.27.00/proxygen-v2025.10.27.00.tar.gz"
  sha256 "250f21c36464b8a0c4bab5825540cdb40a000e2902d4c2e19c1e1a20fcbab946"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "38e6f2f33cf3b3068eb359bcd8723501853052de6e410b120d765fb3149e3268"
    sha256                               arm64_sequoia: "e5c3824774ea132f9a4cd0bb44768e8e9d1a71f2f526ef96b06528d3644a6d61"
    sha256                               arm64_sonoma:  "0408873ab1875daf3e0c2f691802ccc08b88e08c7dc73293775d1cffb7754cb7"
    sha256 cellar: :any,                 sonoma:        "44bf0c5358e2c11dd48f26742ddd9d39347f621d4d92ab38088e64c2d3d0c3df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8af8f79ec88416cff1e6b40c4dd6f0e1136549a131eea2422c7f01d1efd77084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ad98f9457c6f181d50569214e43b34a8c479c30170d676b2b1b849d5960f730"
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