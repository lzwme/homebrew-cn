class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/3.12.0.tar.gz"
  sha256 "98aae3fbed984940a9d6f7ea93ca063c3f4eee3b4f6fff3bf6bdbf003efecfcb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "36921b994d74e483066d9e990482b477495c9fab4b67be2e0d8a13d0cb3f5d10"
    sha256 cellar: :any, arm64_sonoma:  "788f27f874ddc105e4fb2078caa3c2bf3899ac43b9b4bc0cf8ac69fa5e12390f"
    sha256 cellar: :any, arm64_ventura: "d048939da03a2978ce94ad479bbfbc384e30669c8b0983b75f7ec4d10dd5e6c4"
    sha256 cellar: :any, sonoma:        "c2307dd2d9c8d5f3be0a2f0a08ae8c272ae14ed7253635d2e07359aff0da3349"
    sha256 cellar: :any, ventura:       "dcb3f2ac13311738fc2ad08c82d244940c7ee6268803e030933a35211bdc98fb"
    sha256               x86_64_linux:  "fedf25c726743ca087c4785ea5e80355ceb11640dcf84b9b5be4b36c5a6ec7da"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen"
  depends_on "faiss"
  depends_on "flann"
  depends_on "freeimage"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "poselib"
  depends_on "qt@5"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
    depends_on "mpfr"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "mesa"
  end

  def install
    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].prefix

    args = %w[
      -DCUDA_ENABLED=OFF
      -DFETCH_POSELIB=OFF
      -DFETCH_FAISS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end