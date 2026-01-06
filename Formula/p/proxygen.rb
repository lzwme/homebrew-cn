class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.01.05.00/proxygen-v2026.01.05.00.tar.gz"
  sha256 "e4c8f44e5d7b68e7289556713d798ad31d936d80a15a4d4c8b08fbd11d19f07a"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "b0136b5e63282fd210682294f205b460b6d8feadd113816e50d88c9e902c219d"
    sha256                               arm64_sequoia: "9064089f19b497d53023f3f8c3efff9c7213174e59d899dd53c0effb1909ab29"
    sha256                               arm64_sonoma:  "648ed35238d06c138c397fd53d51152d594f1f1314b52c86c7eabe9a54086afc"
    sha256 cellar: :any,                 sonoma:        "ae215221cbc2f99bbcbe58be1ae9bbd684833e5ffda07d5931c86fd8b86c2ec2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5abb4c8233e9c090dce09ee3024c2d3998aac4364136b9d60b9a68c0aecfbda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57e73c784d18979296301a57a095678535ee735667efcf358e2defe66a2e7b6d"
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