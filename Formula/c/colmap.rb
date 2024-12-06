class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https:colmap.github.io"
  url "https:github.comcolmapcolmaparchiverefstags3.11.0.tar.gz"
  sha256 "8da471b0f5baa3bdd940f1778ffe338738eb47b90b4d03dcd8da6b9810014844"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9d34ec14f9932bfc52bc469a759ccd21531fba6b1262df8c2f1567e85f749f00"
    sha256 cellar: :any,                 arm64_sonoma:  "2aab52a0ae8b9fc11056abc7aaeb0486f748e49def64fc076124d952b769a3a4"
    sha256 cellar: :any,                 arm64_ventura: "3ae0841581685adfaac22717aa78ba1ddae8b65fd34a66cc1419bf9fac3269ed"
    sha256 cellar: :any,                 sonoma:        "08736f3bc9b234940b0ea18c84420193300aefa4c4865987bd31de32f8a48b70"
    sha256 cellar: :any,                 ventura:       "85a5f70b854ea3deaa7ed41aab83ee28a4e19e2518006549943763e58cbc7147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6683e33ff087200853478ccce447ee4dee3324bdc9dad23d2f97c2a745768b3c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen"
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

  # patch to build against system PoseLib, upstream pr ref, https:github.comcolmapcolmappull2971
  patch do
    url "https:github.comcolmapcolmapcommita2c44a012742b37ce2ddd163942d3b625cf301c0.patch?full_index=1"
    sha256 "8960a6715ef301108d583646944202d898a043c6fb1f7d09489ebf7fbc9a01f7"
  end

  def install
    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].prefix

    args = %w[
      -DCUDA_ENABLED=OFF
      -DFETCH_POSELIB=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"colmap", "database_creator", "--database_path", (testpath  "db")
    assert_path_exists (testpath  "db")
  end
end