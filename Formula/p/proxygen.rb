class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.04.22.00proxygen-v2024.04.22.00.tar.gz"
  sha256 "450e36f566cac0fbdb6b6c3066fe93d204d544d10b4ace5ab23205ce79d7f2f8"
  license "BSD-3-Clause"
  revision 1
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7e75cca647db729cf04583c175cb38e6a911801d14d13ccaab687bba096e85d8"
    sha256 cellar: :any,                 arm64_ventura:  "7b8a0a604f675af60ac1d3bf94d36e85f4a0709cfd3e2ca11e3315eca019e102"
    sha256 cellar: :any,                 arm64_monterey: "f36f0fa608943952ad1c1d5a4467b1f636b347772892ae0acaf7e3882ad1a20f"
    sha256 cellar: :any,                 sonoma:         "331433d5a048e921cd9c11db763b56b37df676d820f293cc6a0b4490782ee5f7"
    sha256 cellar: :any,                 ventura:        "ec78c4bc56bce86d9305006eea93349b1e6a33f6cd8481fd064325a718aea5b9"
    sha256 cellar: :any,                 monterey:       "8a9e37f1599639741dbf0d9d9838b00a489d94e7dac8074e95f66d6cd6d76485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66ea46f0890e7f52f167f5b44f1c4c3359dd87ae0a469e0dc5ed34cec6a31653"
  end

  depends_on "cmake" => :build
  depends_on "mvfst" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pid = spawn bin"proxygen_echo"
    sleep 10
    system "curl", "-v", "http:localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end