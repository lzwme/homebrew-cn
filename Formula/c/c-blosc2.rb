class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.3.5.tar.gz"
  sha256 "ae3a348fd960f29180e8ee97b9fa3dad1a6a592098f2a3eac82979082a5932d5"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "03f2fbfc97d5b24b3294ee5e5a2e90c7132eeabedc074f37d2529d424cda3d2c"
    sha256 cellar: :any, arm64_tahoe:       "7a87c6b2bd88628b7fa57d87d4e2d1831b6dc78b2299be2bd7c8bf34be5eb79f"
    sha256 cellar: :any, arm64_sequoia:     "0072ccdb12791576f021c95f88d44fa643b1241eabf603df912b02774ea2286f"
    sha256 cellar: :any, arm64_linux:       "100bbe6cb0e5871f4f1560a4381abac8ae4c39152f92cd949692e6ea18ac0482"
    sha256 cellar: :any, x86_64_linux:      "f45c429686113d912614046e55c324f40a35a828bb5530b962d556d0e5594ac1"
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