class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghproxy.com/https://github.com/facebook/proxygen/releases/download/v2023.07.17.00/proxygen-v2023.07.17.00.tar.gz"
  sha256 "b4367bc9dbb92a2de502441a6201e9c4740cc6c4ab578d84c8692edfb7ff5836"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c9c57e772c467adfb00c20d77ab91f444db23eff1a625c7aa9a6061ec6fe2d89"
    sha256 cellar: :any,                 arm64_monterey: "d9fb554aeaee71600a31bd51b281ee9643b3d88b2db99269e8222f5c3282c031"
    sha256 cellar: :any,                 arm64_big_sur:  "3e78193f6deaf5f731d7f46c03b1c9fa79087f6c3d6fba854e1630e383775af6"
    sha256 cellar: :any,                 ventura:        "d01510d0eb3d4fecdb4ae725966565b3677a7c46a2d9b5e091e320410f06b297"
    sha256 cellar: :any,                 monterey:       "0b13b1e13d1aa3b6b6d2f1405b21bf4487a3b84fbd5bfc48c57efdf186777b47"
    sha256 cellar: :any,                 big_sur:        "882222f87dc1f8e2e04889af6e86a23221e1531c50539d5b208149bc192a56f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc593ac2d4492455310e3d62abd3203a571ca4733253e3edb35160fb15f273e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
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
    pid = spawn bin/"proxygen_echo"
    sleep 5
    system "curl", "-v", "http://localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end