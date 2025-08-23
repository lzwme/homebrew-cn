class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/3.12.5.tar.gz"
  sha256 "93dfb220cce24d988506bbb1d27d4278eacfd4e372df61d380559d414c1bd9e4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "7b3c667aae2196f943a0a38b4e18d2937289b839a18e837a1680de7ddf895ba1"
    sha256 cellar: :any, arm64_sonoma:  "e01ca7f2a5658c4061a09731d80e3c2cda622b9495ded534b8071bade6c34022"
    sha256 cellar: :any, arm64_ventura: "7d7b65165b7094bd9dcfbbc8b0231a8bcb13c74fb7d8fb593a219cd7fdb2e726"
    sha256 cellar: :any, sonoma:        "42f00584569cfdd4bbc5f3294b44efe9b0ee16bd1343f823c46b1377005ee65b"
    sha256 cellar: :any, ventura:       "75c0342765efb1b876864ec5953e5bec4c94ca34a0987bc6f8a62a9844ab6cf7"
    sha256               x86_64_linux:  "90543c444a6448cea0f866bc9ac4df3e1c0da551f7e52445e1a7adb30d73ec02"
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