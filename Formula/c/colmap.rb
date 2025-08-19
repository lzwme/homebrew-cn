class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/3.12.4.tar.gz"
  sha256 "320cb5a411cd0aa713adc05e208ec34067638e776260efd8098271342d408997"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_sequoia: "7266dbeac581a559f354eb3dc2b98b04ad4e45d0a30d0ddb97a8fbe312c21ab6"
    sha256 cellar: :any, arm64_sonoma:  "fa30212c72fb1381f0852d243e5a19cbdf292f34a5ef512567d03e2c7635b78f"
    sha256 cellar: :any, arm64_ventura: "02cb3b226825b61cce1ad5e33f71d49d21590dc3bb7574025755fccc90185a16"
    sha256 cellar: :any, sonoma:        "7e5dc731b0299a467f82828bc33c761c6e5307db65bf08f3e8cf3b220ade7b3c"
    sha256 cellar: :any, ventura:       "0e8a9d5c3691d568c3d88be77166c20746ccd72a6cf989f2506003e8d8490000"
    sha256               x86_64_linux:  "676e38f78c95ae2c452be0994a5f94ec1671ed5c52edab8b2aa019cb240f2b5c"
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

  # Fix build with Boost 1.89.0, pr ref: https://github.com/colmap/colmap/pull/3553
  patch do
    url "https://github.com/colmap/colmap/commit/4995ee6ab747fa34372359f1e12f85908bae88b1.patch?full_index=1"
    sha256 "e6112f87997213aabf5a24be8e76a7368b72eee4e96dcd23a28659c5d4292be1"
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