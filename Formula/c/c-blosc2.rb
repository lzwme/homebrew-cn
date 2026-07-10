class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "945cc68d47ba2817279b5d64c0f9b5edce6849a52ac1a46ba8c3ecaedce35769"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d005884a2044d63a254928acf2632326e2fc0275762f2886d2b3d632bf311364"
    sha256 cellar: :any, arm64_sequoia: "f933d68925463fdb3f5a6b46b70895091a9dc3589ac6f29067e3a73788de99e6"
    sha256 cellar: :any, arm64_sonoma:  "5c656c47df7fb66be1a4ac45e63aa831638d3fe09f525f1e613935be8a16f41b"
    sha256 cellar: :any, sonoma:        "8516bd3acc3592d62a7e9473311e984c1fa8b64334fbb1bbd25a632bdcd2848d"
    sha256 cellar: :any, arm64_linux:   "ee3f3bf9034f182ba737a2d202a135e8850be357df361373a49be34add2c85a4"
    sha256 cellar: :any, x86_64_linux:  "6892bbc295557d86da950ae750f7e4b9e87778053c24628eddbd92e8502e802f"
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