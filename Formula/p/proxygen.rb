class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.05.18.00/proxygen-v2026.05.18.00.tar.gz"
  sha256 "d57eeef1f215bafc51fc85085ef20f4a2f6a2156db08a089fb94e72b2ef59f48"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6b047150117ac71856e903cd7400fa568a377476a1a6c6815bb38d3a5a356b4"
    sha256 cellar: :any,                 arm64_sequoia: "c69c9d5bf15d9b80b038beaff4b3a10e5c1f193fd5e1f0f8b19b5787d8f97823"
    sha256 cellar: :any,                 arm64_sonoma:  "00ea07e60d958ae125e9b3b200d36f574b7f5df86d6881309dc6e33e599bb027"
    sha256 cellar: :any,                 sonoma:        "ab554229bbca9d3b9db92106c076eb9e143272732cfcbd8dd46a68265913e8c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07abcf78adb5c49a87923b0544b013527a83e2647a067127edc5183a2dbdfd29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d4b01632bb139621364b5cbb1bc9c9265a83437b45a3dff9b68a10971523298"
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