class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c"
  url "https://ghfast.top/https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "e22b51b810b9c3bdce8c0df0d6112ca8e8a49ce0ea78b504e1bdbb59d731f5d8"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6784390f093bf0bb9f2d03dcc5d35a50e90e745612e12445464989c832c03283"
    sha256 cellar: :any, arm64_sequoia: "0d6f8ed88a35e0c321bf823d769811942333e49e13bbea04f03980a027d444dd"
    sha256 cellar: :any, arm64_sonoma:  "25f67cc6ab34aca8457eb15a390f54bc3e905a615411473b5e951c58db2794c1"
  end

  depends_on "cmake" => :build
  depends_on arch: :arm64
  depends_on :macos
  depends_on "mlx"

  def install
    # Upstream: MLX Metal device_info is implemented via the GPU backend.
    # https://github.com/ml-explore/mlx/blob/v0.30.5/mlx/backend/metal/device_info.cpp
    # upstream pr ref, https://github.com/ml-explore/mlx-c/pull/99
    inreplace "mlx/c/metal.cpp",
              "#include \"mlx/c/metal.h\"\n",
              "#include \"mlx/c/metal.h\"\n#include \"mlx/backend/gpu/device_info.h\"\n"
    inreplace "mlx/c/metal.cpp",
              "mlx::core::metal::device_info()",
              "mlx::core::gpu::device_info(0)"

    args = %w[
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