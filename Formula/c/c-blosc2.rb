class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "3ab395116eae3ce0b7488e994224f85cbc858a7a71663af1f938cc5997a7dddd"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a1496ecef20db7541aa160a402b658372e0209c2787866b50a108e762e41ace0"
    sha256 cellar: :any, arm64_tahoe:       "806233a750a04eb9b490c058fb67a178ac0e35c702d4b2e8f14870931ac206c7"
    sha256 cellar: :any, arm64_sequoia:     "79962f301da11ba02c00ef07b4fd34caa5a774944420f283ef16a414e47d7476"
    sha256 cellar: :any, arm64_sonoma:      "9f4e06e8d5c504d17cfb06670907ef5b1fdd7f8cc2374566e33123354023a81d"
    sha256 cellar: :any, arm64_linux:       "7c576279237c4433931d55b88462cd780fe31cca672f4c12b6eca380a40e0822"
    sha256 cellar: :any, x86_64_linux:      "4fa1977d214e51e78abd5e9d7864eda212903196ba1103b8f84a529770c8ea19"
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