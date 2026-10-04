class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c/build/html/index.html"
  url "https://ghfast.top/https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ee726bb38e191bb3c516a6bae47dc8abad9e5f273873385839019ce46bfceab5"
  license "MIT"
  compatibility_version 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a5ae3a6a1125b04b54580827328ea14f6d4190d3e8151d83d371a4f366ecc8d7"
    sha256 cellar: :any, arm64_tahoe:       "dbbe74c005ad08d027826528ad87db48b172f736288324fa2f9772df892e290c"
    sha256 cellar: :any, arm64_sequoia:     "73bd77660cfd3aa0b40edb6d4d652cb5062a0c8ec0d5fe06550633ad1fa7cfc4"
  end

  depends_on "cmake" => :build
  depends_on arch: :arm64
  depends_on :macos
  depends_on "mlx"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  # TODO: Remove when a release includes MLX 0.32.3 compatibility.
  # Fix gather_qmm compatibility, upstream PR ref, https://github.com/ml-explore/mlx-c/pull/137
  patch do
    url "https://github.com/ml-explore/mlx-c/commit/cfc471f4200f608936bfe68d029b2252075642e1.patch?full_index=1"
    sha256 "3cc6a5c3fb091b7cae7e9da19f72d422122404f61a56c9ce96c2c904ae06a586"
    type :unofficial
    resolves "https://github.com/ml-explore/mlx-c/issues/136"
  end

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=20
      -DBUILD_SHARED_LIBS=ON
      -DMLX_C_BUILD_EXAMPLES=OFF
      -DMLX_C_USE_SYSTEM_MLX=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-o", "test", "-L#{lib}", "-lmlxc"
    assert_match "array([0, 0.5, 1, 1.5, 2, 2.5], dtype=float32)", shell_output("./test")
  end
end