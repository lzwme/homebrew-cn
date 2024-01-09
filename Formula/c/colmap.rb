class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https:colmap.github.io"
  url "https:github.comcolmapcolmaparchiverefstags3.9.tar.gz"
  sha256 "68872fb90832e9c3454e6163676ced84901a30b2bd8fb69d36d4a50fa07c032c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "065708dcf300d48b3d49f474c69e2a07a5698734ca03e5e2b34dc861417b0040"
    sha256 cellar: :any,                 arm64_ventura:  "6483c84df208d0d880efc40525b666f6488c7779b156addb2bc5416fb88aedf8"
    sha256 cellar: :any,                 arm64_monterey: "3c02fa5af9e100965ef121383146bdec9405b735581fa7653ba0954103a39aed"
    sha256 cellar: :any,                 sonoma:         "e6ba8302c7c535eb668362f999472f4724dfbe126cec9275e38166f309e67af4"
    sha256 cellar: :any,                 ventura:        "bc8d357e5a795a106a22d7c2134b318702f16b31b43066fd4c221ea61c063f6a"
    sha256 cellar: :any,                 monterey:       "c5479ce17d60778503638e4506e272d1e6a7eca154c77b48500df426f894475b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56c8377620513227709e83e92505b338daf02c297d858e3900a9fb604be9b696"
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
  depends_on "lz4"
  depends_on "metis"
  depends_on "qt@5"
  depends_on "suite-sparse"

  uses_from_macos "sqlite"

  def install
    ENV.append_path "CMAKE_PREFIX_PATH", Formula["qt@5"].prefix

    system "cmake", "-S", ".", "-B", "build", "-DCUDA_ENABLED=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}colmap", "database_creator", "--database_path", (testpath  "db")
    assert_path_exists (testpath  "db")
  end
end