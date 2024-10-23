class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.10.21.00proxygen-v2024.10.21.00.tar.gz"
  sha256 "4dfb049c9ee82ddc806a7a9ad6bc99d1a037ff6c972fafb7fe07aa8a515ce242"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aba767a078d47aae350fb31abc0cf53b33fc5712fad571d56919d0997ca05638"
    sha256 cellar: :any,                 arm64_sonoma:  "adf31b36f64a408b10e977ca350691c3c88129eacb3a547037440658bf102d3b"
    sha256 cellar: :any,                 arm64_ventura: "7d135500821667cae1d8f0de54ecbbb86eb6274fff590f0b52adab040059091f"
    sha256 cellar: :any,                 sonoma:        "597443c4f3c894d1196fe5bc35a476f34b3f49b0952054ab3629e620561102be"
    sha256 cellar: :any,                 ventura:       "c2c7af518faef93d1356358f762a4b162ccb402af098360009caa5f06a29142b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b9d9705219f1a6f7e264d43c414e0c4fd3012f9982ea640e97d10140bc03d00"
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
    system "curl", "-v", "http:localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end