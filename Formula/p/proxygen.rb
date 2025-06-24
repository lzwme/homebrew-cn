class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2025.06.23.00proxygen-v2025.06.23.00.tar.gz"
  sha256 "0d90bb5ef63b1a5302525480e65228f82262162a8e6086e2de5c69434a6d7ab3"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "507e1808e50cb0de735f8b89d000ee94955acd9ad6d5a6592aa9691c9b352813"
    sha256                               arm64_sonoma:  "9f6c435dd5f7a65c526ad10e571cd89738b0123329fec51df968dc890f26c564"
    sha256                               arm64_ventura: "99eb4ab2abd930430c79e0ef2a2f3d129422ec0905de928b3f8f5a5fd6991609"
    sha256 cellar: :any,                 sonoma:        "4b0a322f7abf55b630adc132e1d3b577e7a1951750cb180acb9d422ad0d14e4c"
    sha256 cellar: :any,                 ventura:       "caef58dc2bdeb0b60495f3f7f2d5f21f9cb05f3f4e6cdaee19f719d4b0b4b876"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6bca6d4f46014c77158e4adf0bd977d39675be2eee3bec523ce18617566194c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0559eda0d214c214c901406c325642f9c3eb850eb7529e4e7b6d02ac1202025e"
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