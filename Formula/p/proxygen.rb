class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.12.29.00/proxygen-v2025.12.29.00.tar.gz"
  sha256 "979a716893f5747569a650f0bfa9da71e807d64b979f930b319d10e0166ecd55"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "a9890ab6c3b91b00ad24b070f46d0dd717df8442baf06a441aef31b1e07e4820"
    sha256                               arm64_sequoia: "95a83aa26ef1dc0c2e84bd9e65ed47e74eda81e8766c00ce6e937d2f81a6f013"
    sha256                               arm64_sonoma:  "387a26c0b545c6321352cf4cd4e0b2619cb11a87b54f6e8c9737e5ca51cabbb1"
    sha256 cellar: :any,                 sonoma:        "e244e1b7244651ca423517bd3659d1d26909444e2c07046b18af6bf2cdc6f7e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c42f470964f114515a7b0b1c366021105516bcc569419ce1eea2529e3071fc43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfcd25011e47a3531b45319407d32e2c943a7f263820bfafc962f219d64b402e"
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