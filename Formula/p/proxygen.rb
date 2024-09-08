class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.09.02.00proxygen-v2024.09.02.00.tar.gz"
  sha256 "76afe33992c821d44c5eda367e6e889a538d87dfd3b2025f64f8010b6130c4ed"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5ddba2ea718901b7d718db48671c748edb473c5e1fc43b66b419ea87edd334d"
    sha256 cellar: :any,                 arm64_ventura:  "0b5f11da4aff7479412da9991368c5add6957085a4c01a1a6506a2caf38ee5ab"
    sha256 cellar: :any,                 arm64_monterey: "0de943aa281e70597f578c1ce49762adcf7d734bb1b9cf8f17302c7970734f72"
    sha256 cellar: :any,                 sonoma:         "48d1e9307008d1743880029f8b9ad8936f934a1626e6c26e012d814a93b4d1b8"
    sha256 cellar: :any,                 ventura:        "36ccbb5d806cf8d8c4ab5c79f3823a8d1be9a904be17bdeafef4022050d63a25"
    sha256 cellar: :any,                 monterey:       "a1ad076606257bda1148be2020b8681c6192e9abe117ec397dc392b36c835686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6999d36e0217910b11c02f67f24cc7df68d36d5d85c193ad036b5295eeab40d"
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