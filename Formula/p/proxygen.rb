class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.06.08.00/proxygen-v2026.06.08.00.tar.gz"
  sha256 "4df9da5a36313e1947609e3f613e461c0c14944e1b7fc35951f0f1a29d22e156"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e358593d355049bcd71ea106d3e2e9a6c2599053ebadc52733d19d7a252808c9"
    sha256 cellar: :any, arm64_sequoia: "c755bcf73db30790c425c1e740fb77a744da525b141784c96c1a0244a4e23c4f"
    sha256 cellar: :any, arm64_sonoma:  "3f8153457d8a981f88ae80ccc76cff79e10fee3810cb5e061cb1f621aad5b957"
    sha256 cellar: :any, sonoma:        "9dbd3b394c73890e5e50ab2e52257598ce37be94c6fd27ea9bd6c4f8b3f3f213"
    sha256 cellar: :any, arm64_linux:   "5cdcb828f0658561d246eb7a5c8805bb63df7f2b79eb6b93b2cb2e8f5449fc7d"
    sha256 cellar: :any, x86_64_linux:  "6a2f2bbee1305550e5de20925298b2c9309ae4188f31755d4a7ef6e7b458adfb"
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