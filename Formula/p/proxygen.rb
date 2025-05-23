class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2025.05.19.00proxygen-v2025.05.19.00.tar.gz"
  sha256 "ab5bfae8e51a538863e9a23026b25a6d93e0aa911b98574ad0e73ca1a0faa7d8"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "4eb0f43db21981c5460faa608e71c85e21089e7e082b8c617310bfcfc71cc20b"
    sha256                               arm64_sonoma:  "6c98e860b04c8b1a0911df41c4e50912c19c4200027bc1b745d61d21e24b4912"
    sha256                               arm64_ventura: "5f2313ec60134d80fbc79313f082742d6e41e434b35b6ff0dc19bc0d04dd78d0"
    sha256 cellar: :any,                 sonoma:        "298fcacac7ca275bd569c8afeb68177adee3678e195d8567eec84019344013a0"
    sha256 cellar: :any,                 ventura:       "2ad6292cd613ef19aeb4242be9166a6ea910a0c2a76a50f8ab5c74aeab5f352f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "013631d7b385b65b46678f831eb0c05d2e92cf3abbc37820979a262e57b58333"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e7dbdb5cb22c3367dc29c4a0b311f1470a0060ce5b2ed75083711d73f36eb9"
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