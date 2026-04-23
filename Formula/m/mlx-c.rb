class MlxC < Formula
  desc "C API for MLX"
  homepage "https://ml-explore.github.io/mlx-c/build/html/index.html"
  url "https://ghfast.top/https://github.com/ml-explore/mlx-c/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6ec2eab86ed3ce661c0d9b834027870651546138b7b4470fa8ef5533498c79aa"
  license "MIT"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "83d092eb6a813c680997c13cafaff9cf6559be17f94eaa80f4aa503dd5e6b8f0"
    sha256 cellar: :any, arm64_sequoia: "721c3c05e50cf23350c725d4b3855ab8fe2ff7265b9e2d61e951b730fe5b2b5b"
    sha256 cellar: :any, arm64_sonoma:  "03127804f9796dfa15b14e4e4faaa19420a182377441a98275fd855ab32fe973"
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

  # pr ref: https://github.com/ml-explore/mlx-c/pull/114
  patch do
    url "https://github.com/GunniBusch/mlx-c/commit/3fce35b0b1fa1160fdf767229bfb84d695ef1e5d.patch?full_index=1"
    sha256 "0361169fe85cdaccfb9a25e3f8a9991951b263b33b7683867972c36dca05e97c"
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