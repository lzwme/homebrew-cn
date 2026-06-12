class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "126f9cf30cd4623426f2c9d959fbad74e1763b6f182a1687b3c576bfda671810"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0641fe1ddbd46f5c1f1b82822b703834a324f41619848c38658a7b8a3696173a"
    sha256 cellar: :any, arm64_sequoia: "12aae049813d1d09e662c75bc09f538419d2fa6166b33b048506a5fe5e2e9822"
    sha256 cellar: :any, arm64_sonoma:  "fc3dc931dbaf2ffe55d01c9f71027076d2f481bece41b8144e6dddfb82f44160"
    sha256 cellar: :any, sonoma:        "cdf393793c0162b58a66f83ff36ad03c645a3ad651f6be8ccad33553879773e9"
    sha256 cellar: :any, arm64_linux:   "a595c66170f40f14a080dea2f1a3eb23473bc9ac1cbf2e67f2c7658d578ddd53"
    sha256 cellar: :any, x86_64_linux:  "a27e375a68f309dbaec471220757314fe502fcde8d9651ff9b9b162cc11647a3"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1400
  end

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_PLUGINS=OFF
      -DPREFER_EXTERNAL_LZ4=ON
      -DPREFER_EXTERNAL_ZLIB=ON
      -DPREFER_EXTERNAL_ZSTD=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/simple.c"
  end

  test do
    system ENV.cc, pkgshare/"simple.c", "-I#{include}", "-L#{lib}", "-lblosc2", "-o", "test"
    assert_match "Successful roundtrip!", shell_output(testpath/"test")
  end
end