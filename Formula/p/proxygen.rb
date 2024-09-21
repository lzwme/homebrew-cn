class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.09.16.00proxygen-v2024.09.16.00.tar.gz"
  sha256 "5ec7cde48878035c9dc732ac75a54d22367bebcecfda9a7adf007a7ea298dfd0"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a024887a420451fb011e90d151d387b7f9adb7ce43276e1ec5473a87a99c5a8"
    sha256 cellar: :any,                 arm64_sonoma:  "11d789f9c0202a282d550ff2badd08144173f7e7a5a543eebcb7b759a449deae"
    sha256 cellar: :any,                 arm64_ventura: "95df6ebc8709f9287053f0c8bc200eb8449ed706c225b9e6ac373d42e5ff29a9"
    sha256 cellar: :any,                 sonoma:        "d02d8f716955095297f298bf23d6c78d9b6dafd422ad82d2f98b207a0976b4a1"
    sha256 cellar: :any,                 ventura:       "274527a369fde6cdad4832e2bb4c3072829dbe6ad5eb1bf54b45f1cd9289607d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc785d352e604e3a922cf0e49e8b5d5197d4c95cb7e7f37eb8626c6a5ae8bb84"
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