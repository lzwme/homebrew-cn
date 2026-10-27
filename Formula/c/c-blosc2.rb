class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "9cf71ec2e205dc7e7a349fe033b9dff8b00f8f26f3e95772d34ab7bbf6007fbe"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0187de7a6cc32f24ace973084b82430c78fae276953d9c58f8cad4f4e7b37137"
    sha256 cellar: :any, arm64_tahoe:       "4bac51e4e528b28b272297ac4481176f4eb0c55ab535e134776b5dec4c8f343f"
    sha256 cellar: :any, arm64_sequoia:     "b7c75f54081c0905c4b74d7fc34d3f140f6259eb8e1a7a672a603f7a8373b9e6"
    sha256 cellar: :any, arm64_linux:       "600011ff1aaededb34770e13545738d40d77058b40b55d281457d1e9f2e2100b"
    sha256 cellar: :any, x86_64_linux:      "ce3a0ce6e6ad4ae6846a6df2a59ca16bae6f2e831cae90e8b941534830868af3"
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

  deny_network_access!

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