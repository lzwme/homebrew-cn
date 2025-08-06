class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/3.12.4.tar.gz"
  sha256 "320cb5a411cd0aa713adc05e208ec34067638e776260efd8098271342d408997"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "036ed2673281eb266377e6bb9068ae083f9f30c94b5b96ecc0998e96d5a8c8b9"
    sha256 cellar: :any, arm64_sonoma:  "e51c148a26d39e4b82f69b0c2fee3f7c50ba3f653b5671ebe41fbdca320ec6ed"
    sha256 cellar: :any, arm64_ventura: "4c8a9e6a9d1e6ed1c156db5973325a7b654072deae04c6c18563bd57b4aa5a74"
    sha256 cellar: :any, sonoma:        "9e2494b9a053aae9d9cab9d995ed5e57a4e6e88a48523611747546ae83c3a31e"
    sha256 cellar: :any, ventura:       "a8cc53d6596c2e60d8dc8139044fd23d731f548c1ca90cfead95e4b8dbc99786"
    sha256               x86_64_linux:  "c3b1d945d3dffcdb39399a1d9445c9dcbda7fb60cb15fad8dd8c8ba316a9c2c0"
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