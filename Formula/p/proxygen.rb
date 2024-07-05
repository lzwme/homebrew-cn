class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.07.01.00proxygen-v2024.07.01.00.tar.gz"
  sha256 "bbf76e83cc431ae069c00ceb59e7488aabece372d276f786f58ca0d39650751d"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c1ba691d77ad13bcc1631b2f63193e4a36b6d55717319b4ac94323b652096b14"
    sha256 cellar: :any,                 arm64_ventura:  "4aa94eef294142a16c47c1c066f747b0c02376996b2cdff568c97e6d8ec6a10f"
    sha256 cellar: :any,                 arm64_monterey: "c32b3320c1fd46942d5d58a60667411d382bac394d9f3ea61e7ec5cab0494128"
    sha256 cellar: :any,                 sonoma:         "498df843fe8e5ce44f41fe372803170804add052ab0e6211b1ce5997d424ce03"
    sha256 cellar: :any,                 ventura:        "f94ec1bccb2b47d7d5c9151994678378c25e297f9d689c5e3387a65bc8e1960d"
    sha256 cellar: :any,                 monterey:       "1da9d7e5cf435d14b52980c40633cf427c98bf4a5dac30b76c89be21541bf96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b8c2adb81f61ff8f44c7feece26910e237bbed80b53762ac2cc863b062a1007"
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