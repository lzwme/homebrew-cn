class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/3.13.0.tar.gz"
  sha256 "98a8f8cf6358774be223239a9b034cc9d55bf66c43f54fc6ddea9128a1ee197a"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a512009c43d01247a7d76e24529bfa60a242c32adb7d69a70c7e6ff51918bc3"
    sha256 cellar: :any,                 arm64_sequoia: "9351f2dda4f45277882acc8d9d7076514d8b092554f72d14ad2f1b6f49884fcd"
    sha256 cellar: :any,                 arm64_sonoma:  "37fd7384d37f2f5929de2b540ba1806fadd10d4e76a7e78ded413953696ec646"
    sha256 cellar: :any,                 sonoma:        "64b6e45de9491adb95c40bd59053da5121f6ae68375dba375df1bd15794ad0b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c70720f984476dc948a4c0173a417a5aa14d7a1a812103ce959db3de22b54b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e965d1c24f2e983eb36223ba438ac4261b61af04e79fba8bdae7245c9fabad78"
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