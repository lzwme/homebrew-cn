class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https:github.comfacebookproxygen"
  license "BSD-3-Clause"
  head "https:github.comfacebookproxygen.git", branch: "main"

  stable do
    url "https:github.comfacebookproxygenreleasesdownloadv2024.01.15.00proxygen-v2024.01.15.00.tar.gz"
    sha256 "d0f28a54e47c76299da537852499aed8a6be9f4aa4ff64cf5c1d17135b15c3e8"

    # Patch can be removed in the next version as it's been already merged
    # https:github.comfacebookproxygenissues479#issuecomment-1899292578
    patch do
      url "https:github.comfacebookproxygencommit343ffcbba4f97ddc2a31570b429ac71ea59f670e.patch?full_index=1"
      sha256 "88561e8876f1404d05b120438134a5479e430f189e6f4a6ae02f1bca64af9ce2"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7cd03a62318e2f9d6e8877eb5352c825166da17476d0f8cd8f0f19204419ec83"
    sha256 cellar: :any,                 arm64_ventura:  "00c6cd02c9af9a31b2728db4d80812e8e89ca09c0d9ee2bf5a4e5e5f2f942d15"
    sha256 cellar: :any,                 arm64_monterey: "cbf0996bae96d1e588836dc6c7e376bb463ffe63b5dc6548a0f11f8360d80d6b"
    sha256 cellar: :any,                 sonoma:         "fe3b03e4a3d2a18dc80bbe0a879626bcf8c0113ac6e56d45a51cab4b78691ba3"
    sha256 cellar: :any,                 ventura:        "cd763f9e0f27376102d21c92e57f9ac9a8fcf49df0bdfedefe5a9d759ed154c2"
    sha256 cellar: :any,                 monterey:       "de6f78b5f14cd0dc91488a784f57e996fd000d3a879dca7d96cce9d80eb25f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47bab0ca8d31fa9492bb2fc5fe00b6fed8ce54d363007d4bfaf644acc6a69fe3"
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