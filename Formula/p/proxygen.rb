class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.06.24.00proxygen-v2024.06.24.00.tar.gz"
  sha256 "26139f9f6f3110e1d696828ffe708af8fde5f9f3a6abf26e4044692407af4cde"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "341ac74c05061c1825bf55530e3a84c28b073b916db3b871dacc4e3394c69a0a"
    sha256 cellar: :any,                 arm64_ventura:  "f3f9ecd51de34561052cfbe82b2395e8fa06c963ac197f59e8d4e5e95e412d9b"
    sha256 cellar: :any,                 arm64_monterey: "d7431288e2291ff6d5b576a6fa964851d714ff82af421242230ded77ecddaa28"
    sha256 cellar: :any,                 sonoma:         "f1b106f6eb481fb7be485e94f6d211fdc9ad43f5c7a8d44fe1a5d451a62ed443"
    sha256 cellar: :any,                 ventura:        "7bbe89cd54e2c5f66c61c233096206f40ccf9fa24b34132e54876bf4cb7fe832"
    sha256 cellar: :any,                 monterey:       "3513303453a649d78e4bde4fd8c4ff1d0b46db5ad3a9ebbdbe1ac927398101e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6345dca0ddb63f97fc5f06e6eedf662198588cd915c869fef80f064f77789b2"
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