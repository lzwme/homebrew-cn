class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.07.21.00/proxygen-v2025.07.21.00.tar.gz"
  sha256 "fa6992df4aaa846a8ddf1ab5df1d8a7784b0ed4af3e3c794ed47ea53316b8513"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "f33e43a429c12ff2b5b503e3b35743758fec40a982a52205e1f8dbc545c0c61c"
    sha256                               arm64_sonoma:  "a6207e5e6f0baf2f1fe23650b911ce1c2942c2c132c5f71b28f17a8170f574ec"
    sha256                               arm64_ventura: "6c8679f161cad22853825ebefe8f6a731afb10603b9c4970cde3c3d762abf5c8"
    sha256 cellar: :any,                 sonoma:        "b60fd03a85ea01d9c65433b66e6e848d4ce57ea9e404297ac6c27974942700af"
    sha256 cellar: :any,                 ventura:       "0fdfdeb458a4d273736709f9576875faa82e218b8257ba8823696f0be170b484"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be8304fd0542e6cfd46de0e75131d62b2c9723f53d1dd49f22b26e1e2f8fe171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "007c964ac6eb2b3981cb67f537ee1e6648aa4070259f6c8710b2539b0a441db8"
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