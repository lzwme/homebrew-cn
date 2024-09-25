class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.09.23.00proxygen-v2024.09.23.00.tar.gz"
  sha256 "cf5e1b4a21abab7992df49d95431298788415485d38b2d37d0d349dc731e414d"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b6d07f1b6d3a8190d61aaaca6be4a40b783741d4727c7b1a2af18e61ba0d1d4"
    sha256 cellar: :any,                 arm64_sonoma:  "a194933e436c02ce9d1e82c919891065fa52760c47a532cdea593604d67979ab"
    sha256 cellar: :any,                 arm64_ventura: "e99210d646243c327d70651be523c48c770d79457d2fc00f91db749beee9533f"
    sha256 cellar: :any,                 sonoma:        "db590f5391cc55a948d06e2b20dda0654a9cc953210b3b27eafbc372c65ec6a9"
    sha256 cellar: :any,                 ventura:       "49ce3efc6bcfc2b44968413c7da19cd20aa8561cfff7dc27710282b23ec3aae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a190a0adca25512029bee53d6d9a8f84295916c4ce5616cd7ee9727b70b8a8"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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