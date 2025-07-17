class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/3.12.3.tar.gz"
  sha256 "1ad69660bd4e15b9cdd2ef407ac11c8e39bdcdc68625c1d142b0d8e80b6b2aa7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "d9d6f8cb33f720fbba71e593b599344f12c3c4a131586be0c1539e651d40c16e"
    sha256 cellar: :any, arm64_sonoma:  "612ee1e6048a17d389c6ab765961c1ab28a7e598e7a8ce6ec4f44e1e51b146a1"
    sha256 cellar: :any, arm64_ventura: "a51bd2b6e44de62547fd7d5b7d5fd7cbbfedca51dcca8c6c42fb50e12fea3581"
    sha256 cellar: :any, sonoma:        "910ef8963bb937e50396a95aef4762183a61ba9af68d65b6f4d449a59f8491bc"
    sha256 cellar: :any, ventura:       "80ad3f78825fc410a8b354fa59c267cb470498553fbc742d891e2f240c8d573e"
    sha256               x86_64_linux:  "96fcb603aeb36314e0e49461ea7a6ad21c375b38e71ae77fac46813783011481"
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