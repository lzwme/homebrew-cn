class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.08.04.00/proxygen-v2025.08.04.00.tar.gz"
  sha256 "4d342cab1a4c822cdb18ed28307782f629eeedc18ea6b679c37005af14bccc1d"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "b13d5a568c9b534263e46e1e799dd5efff21eeca59e110435cd3f9c05d62a6a2"
    sha256                               arm64_sonoma:  "b968e96756461259d8e3ffa98636fcb14c55da8162093d73641c54610d3f09e1"
    sha256                               arm64_ventura: "4b9d5ed5f56f2fcb1fef9eb33a48518309321776c1d69ac88399e69b9cd5bf64"
    sha256 cellar: :any,                 sonoma:        "21704a9b55869b2005d99b557158f69712680a722c9e59c16ff0369918da60e4"
    sha256 cellar: :any,                 ventura:       "b56d6b32677bdb1aca77ffe2d1e8f3d7005450eb2a3c972c4f5ff025f612816f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc498fa9ee2d773396101370767d8fe184a56b4c845cd112eb9ba2bd8871b56f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46ea882cd7e0ea19b9ab0087ec401470a5d628418eaeb0998287d9724907ec92"
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