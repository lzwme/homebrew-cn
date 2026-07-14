class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.07.13.00/proxygen-v2026.07.13.00.tar.gz"
  sha256 "975bca351b4072fffff74f108cfe3950b5050484f87373e1e1065e4f2f77f07b"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0cc6bd1280ecbd24be0687e3f9010552bf4752afa09c35756bd7383edd6f9735"
    sha256 cellar: :any, arm64_sequoia: "4e7c9f5ef415b3e0b1f55e72bcf7a57349e6fafc4ddadaceea2bcc02437b8cd9"
    sha256 cellar: :any, arm64_sonoma:  "4358ca2b9352c4baf622a624c656b58fafd4b462f9ef74db98a0a48074b24a2b"
    sha256 cellar: :any, sonoma:        "8667a1a67b986ae627a8de1eb762b85149bc10f8143e271b5122392578e0e61a"
    sha256 cellar: :any, arm64_linux:   "e9195ff4a81278961398f654f31804ad504f0e70a4765a5c45403ba1c9d61b96"
    sha256 cellar: :any, x86_64_linux:  "63f941ceca4a09db1d27d8a4908f541e705d3a56f5825067897262a8898e816c"
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