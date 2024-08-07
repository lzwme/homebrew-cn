class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.08.05.00proxygen-v2024.08.05.00.tar.gz"
  sha256 "749fed51af4f378f09989b0c7aaa26e32025ce51c4bbed999147a1d460caf7b2"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "17d82b6f67d2161cf4fda4416249fb8d3d97685ed3b1edebfad0a5c9aabe6a91"
    sha256 cellar: :any,                 arm64_ventura:  "b156538655142a6d6ec940810ff86627da5ee37d4d690c17601a62f6b708a301"
    sha256 cellar: :any,                 arm64_monterey: "eb542d9f13e5e147526d4f61c3892949d1d2c1030a030df7faec1b2ef0185ea6"
    sha256 cellar: :any,                 sonoma:         "8992a50ecdf96cf234bde413ad069a38ba7b433aefa3936d58b886fc508201fe"
    sha256 cellar: :any,                 ventura:        "6c3cb93f48788a13864151ad73f5f5298fddc3496c0bdc91c3a1ea3f32625a50"
    sha256 cellar: :any,                 monterey:       "2fd1284cffca751f1c0b7e6f25f645c5e37b71b4e7f804169437ffba4c7808f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79fc25cf3ca5528be213ae982b47a949cb19698ab0c93a6fdb9ef3800cf270ce"
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
    pid = spawn bin"proxygen_echo"
    sleep 10
    system "curl", "-v", "http:localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end