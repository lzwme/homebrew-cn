class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2025.02.17.00proxygen-v2025.02.17.00.tar.gz"
  sha256 "957ae1c263a8c2a903eead614182a7503b1a1fd784543ac7e065a65d54d31d8c"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4042f70c412641bafbf6d1e034512fce25efbb8c915d1d20816909bfe66f43b"
    sha256 cellar: :any,                 arm64_sonoma:  "0cee408a6a79b97998b1d2452aaf93edf362639dda52dfc99ffb4c5a604e8769"
    sha256 cellar: :any,                 arm64_ventura: "93ef6fafc59915e2fd3195c0be0098746e7cf79489879d43bcdbde174748de7f"
    sha256 cellar: :any,                 sonoma:        "eac71129817cfe93b93eb4f652ec172401f3201eb8f74d86bc8380ec65d531bb"
    sha256 cellar: :any,                 ventura:       "6e9751867c062b07cdf080f6512bba23c7bd2863ec21ed2fc29be6c3014e560f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae5f20d44a39953c9a97f5305eee644a1f76dce70d487ebdd1512563b17cd6f1"
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