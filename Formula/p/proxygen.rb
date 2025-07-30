class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghfast.top/https://github.com/facebook/proxygen/releases/download/v2025.07.28.00/proxygen-v2025.07.28.00.tar.gz"
  sha256 "37c40f1429fe05e43771cd6c09f410259aa945bd3749a5dd796fa7261e9403d0"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "a67b15f3808a5a03a5946e65fc434eab8274e28dce287587dac586f6beede828"
    sha256                               arm64_sonoma:  "2a85d2649131c3f8036e6b8a6200321161d6f99c4fb4b48044687bf43f19c053"
    sha256                               arm64_ventura: "fc47c006ca63e85671e54d19ca682444be835c4f6ada10cc26d1718ad4c9b552"
    sha256 cellar: :any,                 sonoma:        "814d1462eb7175625c26e750a967a1ac8f208e64263687e3d47671c075390047"
    sha256 cellar: :any,                 ventura:       "e5ed00939bbe853a358966ca46ac7fad85e686513ed8e455f65a8deda8efd58e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "705542a4ffd5e13927f352531cd768e509782eef2ed118c37bbf3f023761e600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a93a079efe4baa129d99cdb7355ea586851ebac9c2527b69f4c8dfcbc22a035d"
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