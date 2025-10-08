class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/3.12.6.tar.gz"
  sha256 "f66d34be7a738fa753d1b71aec4fb7411d8c117beb58d1f2ba84ee2696c96410"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "636dda7a476847cd390b24ccfaa54588a068b4cc5a21b0ff55ef2f116272f27a"
    sha256 cellar: :any,                 arm64_sequoia: "aee8f246d50e04e7c3cc551627e890632f9038a9abd97fe421e71cec2217c38f"
    sha256 cellar: :any,                 arm64_sonoma:  "8799ef68c3de223d423ce3fc3dab7dfc2adf1d0b9afeff0f30ab37305e06b577"
    sha256 cellar: :any,                 sonoma:        "0eec12940518cd5aa0866ba3b875580d6ef6691eaadf7b3d93cf2a21fc40ffae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04bed90470071ac42ca664ed2e86df2f58ddce598bff88bbde1619b5236ed96d"
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
  depends_on "openssl@3"
  depends_on "poselib"
  depends_on "qtbase"
  depends_on "suite-sparse"

  uses_from_macos "curl"
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