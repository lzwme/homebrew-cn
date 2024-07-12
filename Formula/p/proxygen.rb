class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.07.08.00proxygen-v2024.07.08.00.tar.gz"
  sha256 "826e78a4d7452b6e24cc990622d5d226aea21f8e2f16fb6a485dec4c2d57beea"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a88cee67a82ab94ce76d24c35d4a03785563cc965ca54b672a5e078b6a2c6e2"
    sha256 cellar: :any,                 arm64_ventura:  "85a549c3693c0186273061a91771d97df682124957594b89c1baf482af5ec4e6"
    sha256 cellar: :any,                 arm64_monterey: "186954cc26fe4228a4092a7f91d0bbb15fac1dfa859307f15b972c9af998025d"
    sha256 cellar: :any,                 sonoma:         "b4ac0241e94bcbb4e5db634cd982585ae5fb86880d4228764295cc2051d201a0"
    sha256 cellar: :any,                 ventura:        "3dc1aeb04ad40ce12e318bd0342284bcc01231c1c8c0269db2227b57f0161c7d"
    sha256 cellar: :any,                 monterey:       "94813f0da5d104578db411790067a41281d9ee2486b709e602626e4e19c8dba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eadc6edef4c95bf395fcc82e01631b84d12da58bd133ef744646b8fea11119f6"
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