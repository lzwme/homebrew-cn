class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2026.03.02.00/proxygen-v2026.03.02.00.tar.gz"
  sha256 "9a6bfc54ad2adebd7dd2d1a9afc6c659601425a9abcbab0727fa22112b235106"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f323df59ac682cc6a7b558de220ce75837d424a8e3cc109a6764e2a045038bc"
    sha256 cellar: :any,                 arm64_sequoia: "debfba1e2124b57808f06886cdf165be4b4cc0198a7463b7144dbf9cf06156ff"
    sha256 cellar: :any,                 arm64_sonoma:  "4694ca6c802537294c94a11f0d7c82552753188a5c5c9fed4f5aa955f5c17abe"
    sha256 cellar: :any,                 sonoma:        "1cab9eb2c970cf375ae6397ef9c635cf5f2c08452d63982de7ddb2f90d66a103"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12b39578f021d4606cade97a008bf3ec7c7edee645196ce1aa5a8b4ffbf9739c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "235dbcc4827eb09c4eb19ce7b414fffec8964e541a80c63de18fd1f9d3287f56"
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
    # FIXME: shared libraries are currently broken. Unlikely to get much upstream
    # support given `BUILD_SHARED_LIBS` says: "This is generally discouraged".
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