class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.04.01.00proxygen-v2024.04.01.00.tar.gz"
  sha256 "8b3e492f6bb4ea14bd58da9c82e6146e6052eb3cacbc8bf2d5f4bcc9e7b56c8e"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "331d1ddf001ae6a973927a5b857c5476a702bdd435475e3c3be8ef987a9ee036"
    sha256 cellar: :any,                 arm64_ventura:  "48de73a1b3a1f764040ce627742e757d31bc4a8e3e8d3e9a375d27caa3b5a722"
    sha256 cellar: :any,                 arm64_monterey: "6a09e84b449473ad549fc8567421a1a52305045be771f531d53b0ce0b7148cb0"
    sha256 cellar: :any,                 sonoma:         "7bef5a7ed9d1caf5cce4511660b2cacc39c52976c77ded82c2bd8912f137e233"
    sha256 cellar: :any,                 ventura:        "b20fcbe96af5a76a05c7ec0cfb8eaf1010df10783f82187d66928a50ea708695"
    sha256 cellar: :any,                 monterey:       "0f5a7e45906339d4a6ed2e0449435a8d1a3ab5a12e2ae692b3f5b1e6ae41fc1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc31259bf96329c9feed7573aae7f313d3497cc70c8154335f2fd14d0291c93"
  end

  depends_on "cmake" => :build
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
    sleep 5
    system "curl", "-v", "http:localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end