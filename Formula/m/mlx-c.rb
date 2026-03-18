class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c/build/html/index.html"
  url "https://ghfast.top/https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "dcfc404d7004e6da70170c669dbc920913cb25a59c9f7dac781caf92e524cc86"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4308e8bf4632333803c8c2e2d91bdcdd540469a2d216f9be7e79c536beea0f31"
    sha256 cellar: :any, arm64_sequoia: "9a4aafff7fd5989916a0787a796e530667d39541ff88cc1bd95cf7adbed2dad1"
    sha256 cellar: :any, arm64_sonoma:  "7d945c445e646d8e2f7e81f8d97bfa2f0cbc320b1dead12ffcc231c1ff4ceb0a"
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

  # fix build with mlx 0.31.0 API changes, upstream pr ref, https://github.com/ml-explore/mlx-c/pull/103
  patch do
    url "https://github.com/chenrui333/mlx-c/commit/1a51ff8cd618e1967f71fc37cba7044fcf3e746f.patch?full_index=1"
    sha256 "2256935dce8e552bd8f143ec279bb0d11fb802eeb23ac868e4d28c506ab72a8a"
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