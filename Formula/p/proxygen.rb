class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.11.03.00/proxygen-v2025.11.03.00.tar.gz"
  sha256 "3b64379efab47c4ab434b9e01a2bb02a50b109b73455e9d1074801dcdc278c17"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "263b45b8dfa392419a6dd5fd7606157eaf0574f187cc19ee232029de215682fa"
    sha256                               arm64_sequoia: "cca99fb3226ece0e881d0cd1e85a6313280d9e60380de8168d6ca36c443c3bb7"
    sha256                               arm64_sonoma:  "26e5daca8f0f9062f26023fb96b8ebe2e61c7c4727645603c2f459c2d2ecc0b0"
    sha256 cellar: :any,                 sonoma:        "f6b76e07a84d7b6fd0059a5fb57f53a9b25c299daf01bba4e0f7e9807c6bfa96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fec5204fed9837fe4497dc6b1c7a60727d5db7f14771d06ffedced38aa32459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f96cfa5d809f1b71562bac3be9cc9f64d8618e5a49b7e68e7bea2329070a02bb"
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