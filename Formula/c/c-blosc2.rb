class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "535f2165906d59cba0783ca8cd286b358a0c23493e2d9c4c2840569498a163d0"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee7183bf903abc5f4cbd02e1f80f09bb3de8b986d11e74e14bbd7be089d88521"
    sha256 cellar: :any,                 arm64_sequoia: "48770f6d95388926ac9e0b441da30ea5a9950eee0234b97203787a3305955ce5"
    sha256 cellar: :any,                 arm64_sonoma:  "617a3482c3f126c6897cb3d064d5a3f63e2002e964d08c46a0d27988ef5090e5"
    sha256 cellar: :any,                 sonoma:        "f01328ed01a2f9dd20c6300e151a914a055ba84f85ebe7e9e79d6bcfc57468c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3c38f0fa1b339a85a7b388ba47e1eb0455f6b111bb5dce912e3adb171a41de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "594ccc29ad3cc74131a192c1d7e4cf4a4f9403a8152578c2274e659ce3eff6ec"
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