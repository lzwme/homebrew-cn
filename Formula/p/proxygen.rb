class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.06.17.00proxygen-v2024.06.17.00.tar.gz"
  sha256 "c296c57e611168a5f3e91f2c37e509f92b0ffaaa21ecb14d0370aac61a055ed1"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d06676fc29808dbb216b65427ee459b67bdf872425942dd3b1694c99cc554b87"
    sha256 cellar: :any,                 arm64_ventura:  "63725eda9ceb66bdbc85168855a65c834427cf2ab9188401a582f531c39a2a1f"
    sha256 cellar: :any,                 arm64_monterey: "6b321b7bb2ffcc2814768c532ee1fee00ec2afbf2a1dbb402c766d4420f64b32"
    sha256 cellar: :any,                 sonoma:         "eae33ff6d746337636007e3306b1a0d79407036efe4dec468c9407da8e645dec"
    sha256 cellar: :any,                 ventura:        "8731156d73552b1389fb41890f8c7f906939fa834f05e1ef3eb7128a09833750"
    sha256 cellar: :any,                 monterey:       "273d49442867e0c318efbf151037e31ceaa1533486b3294a560645090d8795bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c8b4dea5a05a2c0c69ef60b196700bc647fedaf54777c134b25fc7e90c10c3f"
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