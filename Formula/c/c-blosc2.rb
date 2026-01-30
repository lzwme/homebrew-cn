class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "125e0ac2fac3d81239c1de036cb335bc8eca86b19216e97e0b23de3283d3274b"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7178230cfd6749dd6ee7481c33ec6caac7fc57d9c089b884aa550917b37caf80"
    sha256 cellar: :any,                 arm64_sequoia: "b44e42f3fd7aed3a5fa21818b844fb53344b7e984c82cf61637ddda43e15ca18"
    sha256 cellar: :any,                 arm64_sonoma:  "0d0107db587b44594e608ed422686529f76f842a3c468c38d1e8584fd284daca"
    sha256 cellar: :any,                 sonoma:        "3e4eae5fb8da844700b5f4a59a0b39981ac4aa09db4e76e4d67a9d6cb768e9b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c8c9bbff32662e8e10cc0d6f434bf199be08e6b5a7a4f6f094b8b97e4414835"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc5fd46626a5cbbfc8b26e2124b2998cde30f4de6fa0d1378abb6af0e82864f"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    rm_r("internal-complibs")

    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
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