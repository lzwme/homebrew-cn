class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/3.12.5.tar.gz"
  sha256 "93dfb220cce24d988506bbb1d27d4278eacfd4e372df61d380559d414c1bd9e4"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:  "f30b343b6a57e5455a19b70b1d50d493a1466b48f1b64acbf24602e07059e335"
    sha256 cellar: :any, arm64_ventura: "32e1527cf7ec53e989b9d1fca76bdbf57544679044971b0e56a1a9ddd523822b"
    sha256 cellar: :any, sonoma:        "9c6e639171b656295978741177bd1f09c792c27721b631b72833bf6c4912ca30"
    sha256 cellar: :any, ventura:       "009de8b69f339954254259379a70e0da28f96802b40cece12f5d9c5f5d90ab4c"
    sha256               x86_64_linux:  "8fa780ef4d4efc4abdf829d0afe66a03e1fca6c553a4af158ad05fbc1886d465"
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
  depends_on "qt"
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

  # Backport support for Qt6
  patch do
    url "https://github.com/colmap/colmap/commit/1625d9e8c97aa8beef0df0c00430c1c3d79190ab.patch?full_index=1"
    sha256 "146e444bfe7209b046a8a5a9f14acb84bd381295ba7f2cc70a38f768e9137136"
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