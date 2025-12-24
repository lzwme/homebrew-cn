class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.12.22.00/proxygen-v2025.12.22.00.tar.gz"
  sha256 "46fc56c0663ea930377ef529e679eff8b49e24c9d1c8059d80b493f35f44c59c"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "abc19e1ffac9345890c7bacf43784cbdae4b1714565545ea61a149d9bcdbf36f"
    sha256                               arm64_sequoia: "339970644670b28e1e203f282d9b9f44fe0199fa68d883e5e2cb1f77fd08febd"
    sha256                               arm64_sonoma:  "7f5380cb3e3a1d425b2c15638282f95c0206409a0127e55447c92f2e00797a69"
    sha256 cellar: :any,                 sonoma:        "5ee82f6d9bfe1ad6449c6d24c6bc63b48f6bf589fa53e47ab38df6679008e623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d41091cd69bfa0a5ad938ce265edcf7b76fd654a13c8c9614351972a601568c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7845d9a5495950f2e9f67acb39736bffb7b9aeab71553de6f6fc2b2dda5acabf"
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