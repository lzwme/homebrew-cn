class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  url "https:github.comfacebookproxygenreleasesdownloadv2024.08.19.00proxygen-v2024.08.19.00.tar.gz"
  sha256 "167f90ef3dee232888a03f60945cab35f1e535aacc6fa844b13e37ba742ade27"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "70817e279aacf7ef2216d9a70ae18eb4c0a00e96a98e57ad0955339a24ef1b46"
    sha256 cellar: :any,                 arm64_ventura:  "a06fe300f83834a03b57211f49171d4dacdf95601c76d329733cd3540d125ede"
    sha256 cellar: :any,                 arm64_monterey: "c4ae29414bdb2e2b1360c310950dd710568136c41ea9b278b594dfdca9a7788f"
    sha256 cellar: :any,                 sonoma:         "bda3fa65da0426b59fc8743c65f6ada465bf0979cd85b6c33aefd960d367c990"
    sha256 cellar: :any,                 ventura:        "884d8ddaca102b9cab0b2555da6c3122552e3eb97b080de597956283e60f7a93"
    sha256 cellar: :any,                 monterey:       "18f87a4b061f10239e58b40c8aa3e8b2daaa9d59b19ec20f33960511e962ce66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecefa2a9c7474da81cc0eb6312fa30b7a9b38888f358de0897751d9bb3789ede"
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