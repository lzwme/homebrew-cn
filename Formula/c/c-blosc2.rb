class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://ghfast.top/https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.1.4.tar.gz"
  sha256 "085a2f4e3ea66e7ca4ceae17873e1a5fa4af7f72cd0286d0dd175bb864278960"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c5cbf3b57cfc4b862b8df3dbfffde5e0352b2c6a2d5af561b5e18bfa1a958595"
    sha256 cellar: :any, arm64_sequoia: "3d2616c9f3e53214b4ef31cb4af1a67173104fc5e5be7d137b034a9aa61acbf8"
    sha256 cellar: :any, arm64_sonoma:  "e7396aa5297737ad3f450048fd7f877c010539cf25337eb1fa2709f47ea3db18"
    sha256 cellar: :any, sonoma:        "a7a0a2fa5de2e807a16534a4af057d8128ea348d663b4fb5b3a0a1c43df2e950"
    sha256 cellar: :any, arm64_linux:   "53737b8dc35b59c33e073ac0cc0f3bf1a0b926aca1fbe6ec72f7b50930d636b2"
    sha256 cellar: :any, x86_64_linux:  "080a72403907207db640bbfd16d652a5e9c957bb8d98e89e2beeedead90b0e70"
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