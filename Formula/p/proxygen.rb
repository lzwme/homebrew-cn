class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2025.04.07.00proxygen-v2025.04.07.00.tar.gz"
  sha256 "e76073abb0a3d70bec267038103b45c3f31c5d6012cc53ed5f8386acfea7789b"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "eba205fecc1bae9b7d8c4828054c7d2ff1314c3e68bff19e17f8b45c43daaffe"
    sha256                               arm64_sonoma:  "a5cb5ea0040b75ee46962af852cb2c86cc78a1be993a4d21eeda5e5e569981c9"
    sha256                               arm64_ventura: "e4dbf7eb0978c2ad8b72e0414216ba5a3abf5fd92fd76f0ab64e0b3819f339e8"
    sha256 cellar: :any,                 sonoma:        "7cdf30f531206958cd45e50429e4061a9d4e275ea3a41d00929575069bda265b"
    sha256 cellar: :any,                 ventura:       "5c1f61950d52bae7715d31c5bbb98a5238c19e8c0c2f44e78418ae7d17ea3a81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e6f5580932581e19330aef51923cec5723be552ba0ba63870bb22189ac29db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a42a92d9fbd7c55c98fb1b5c4824846049691c1f7de3b187e309cf76be4be5e"
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
      url "https:ftp.gnu.orggnugperfgperf-3.1.tar.gz"
      mirror "https:ftpmirror.gnu.orggperfgperf-3.1.tar.gz"
      sha256 "588546b945bba4b70b6a3a616e80b4ab466e3f33024a352fc2198112cdbb3ae2"
    end
  end

  def install
    if OS.linux?
      resource("gperf").stage do
        system ".configure", *std_configure_args(prefix: buildpath"gperf")
        system "make", "install"
        ENV.prepend_path "PATH", buildpath"gperfbin"
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
    pid = spawn(bin"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?
    system "curl", "-v", "http:localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end