class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://ghproxy.com/https://github.com/facebook/proxygen/releases/download/v2023.08.28.00/proxygen-v2023.08.28.00.tar.gz"
  sha256 "edacafa58adc01dc8764a820d21b54f05bdf0182544a4c6ae11fa0246e9664de"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e3597904cc86833281647780b97c42d464e496d8cc1e7f9563bf0a19e08f46f4"
    sha256 cellar: :any,                 arm64_monterey: "77cf6758869d0e4f58cf0ec7b520ba7859ba6e58955973afb0ce19a44d5087da"
    sha256 cellar: :any,                 arm64_big_sur:  "64f3fef812db401e58e452637169d70545da6a9b571b8a74995229a5837e9ec9"
    sha256 cellar: :any,                 ventura:        "b9921b30877c17892d78fff76e23fcdfd025e2026a0b459c43f1398fcba00910"
    sha256 cellar: :any,                 monterey:       "5d553b0bc33ed35915035587a17f28090249500b071e301138f02393e8cc4f8d"
    sha256 cellar: :any,                 big_sur:        "4bc14853e54d82893caa620f614c753e9c7e2f275491e690ea6617b406fc5c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54ba7161e7e2548136547a39b4bc8c4626aa7ced23f814f31c1007702d5358bd"
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