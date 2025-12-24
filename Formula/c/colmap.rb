class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/3.13.0.tar.gz"
  sha256 "98a8f8cf6358774be223239a9b034cc9d55bf66c43f54fc6ddea9128a1ee197a"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ba8ed6e3f70bfe2560b9d3d4462b6eeac1719da5a789b3663f06823bafde2cc"
    sha256 cellar: :any,                 arm64_sequoia: "632b36db12e38121984e32d5891521a7fa2d076349fa324ab67f1bb7178967a1"
    sha256 cellar: :any,                 arm64_sonoma:  "46536025c0f94e5ec4031bb06bf4f2140d7f0b1e75774809bb5297647799ab5d"
    sha256 cellar: :any,                 sonoma:        "c0124b7cbc29cc5ac849ba38ecfc63accefa422d860cfa8c3b12284c5f9b1e66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16fff1997276d9c58e1e9bf2a876c0ef72df1fb1d1a62c6122ee46a0ed43bba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4b41989656c3896c905a18858eea609f83366c9b46140d5b344c0aaf61905d1"
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