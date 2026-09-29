class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.09.21.00/proxygen-v2026.09.21.00.tar.gz"
  sha256 "7144f76b1a47424d82a432b55522f7391f7fc3b5d46214238b1bc3ba4d529476"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/facebook/proxygen.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "399b55f1fe66c4bd8ff9adcbc49003bfa817c3bd4870dc2e56fde0d4e5e01720"
    sha256 cellar: :any, arm64_tahoe:       "7a418603bdb7abc3e535bfcf50cd58e4bbc78675210df636d4f64ad47a988f71"
    sha256 cellar: :any, arm64_sequoia:     "e8fc672331a210a2e35c0bd76a4f9530456ebf7d24e734c52ccf5237eacbc0ec"
    sha256 cellar: :any, arm64_linux:       "b1a5a80a968c75d5245d0529eb09ae9120c562cefe4aa81492b677d7102dac96"
    sha256 cellar: :any, x86_64_linux:      "14c68b97f017ef5a0f99deeea037ba327a1b8670708567b5ccc4eb0fafaff31a"
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
  depends_on "openssl@3"
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