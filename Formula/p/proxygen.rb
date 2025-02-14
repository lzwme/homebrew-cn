class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2025.02.10.00proxygen-v2025.02.10.00.tar.gz"
  sha256 "957ae1c263a8c2a903eead614182a7503b1a1fd784543ac7e065a65d54d31d8c"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b2827da96e91b2f1a3cb98f15927c0445438499b1f479da46c1b7eaa2bfc6f75"
    sha256 cellar: :any,                 arm64_sonoma:  "6808af43a5f4b9db0080329695ec29bb0cf935294132d5fe9ab06fb4a1162a63"
    sha256 cellar: :any,                 arm64_ventura: "7499aa8c8b2c21aba350a5fc04871fdf64fa14af880fd4bab41e93690ef0119a"
    sha256 cellar: :any,                 sonoma:        "ba0116bebc4170d5349c293f0d90e7ec2ab63438dd80d2526286fde90934ab9a"
    sha256 cellar: :any,                 ventura:       "0cd5ef6aeef2597f3409dc2fae0a3798f3d71533f62d677dd674d897e4d87e14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d9435eeec108b95dd527ed85b3255a7a2f045382f4312770e963c8433c88607"
  end

  depends_on "cmake" => :build
  depends_on "boost"
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
    pid = spawn(bin"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?
    system "curl", "-v", "http:localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end