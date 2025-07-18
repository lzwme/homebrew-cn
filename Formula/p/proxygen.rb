class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.07.14.00/proxygen-v2025.07.14.00.tar.gz"
  sha256 "0ed103c6a3e04110a532e03f08a3efdfa1b79e2c6054d49e8300abf7cafd0655"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "7270045940e54e54efb3f2984c5c026159dea36bc6352cb74304ad64148b3c4b"
    sha256                               arm64_sonoma:  "7a642e793121d9f2124b491d79ae7af33aaeab72e1037e261af2e68c68ff3c5a"
    sha256                               arm64_ventura: "65364b206d393a6b54e22dfe2b960aeb67086189cfe7853f9cdf2f3f91090f41"
    sha256 cellar: :any,                 sonoma:        "296191a456d08b60078482a4a23c3bc2da9c6d6dbe797384f8d08ae0bb153104"
    sha256 cellar: :any,                 ventura:       "d96a8ff55526053ac1531f436176db0a779c69371d353eb66d71596f57eb970f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9904ed105ded4a27989bf3855a2ef5f0af944064aec95fa72fff66354c888e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbb372e33394b6fbaf86f4e01e98994fbda3599a497adeb20fa407c4f95353cb"
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

  # TODO: uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  # FIXME: Build script is not compatible with gperf 3.2
  resource "gperf" do
    on_linux do
      url "https://ftp.gnu.org/gnu/gperf/gperf-3.1.tar.gz"
      mirror "https://ftpmirror.gnu.org/gperf/gperf-3.1.tar.gz"
      sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"
    end
  end

  def install
    if OS.linux?
      resource("gperf").stage do
        system "./configure", *std_configure_args(prefix: buildpath/"gperf")
        system "make", "install"
        ENV.prepend_path "PATH", buildpath/"gperf/bin"
      end
    end

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