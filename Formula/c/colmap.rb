class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https:colmap.github.io"
  url "https:github.comcolmapcolmaparchiverefstags3.8.tar.gz"
  sha256 "02288f8f61692fe38049d65608ed832b31246e7792692376afb712fa4cef8775"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e1ddaf96fa7c3246de12e1d65cf2ae527ec008cef19849a3e0eb320a31329360"
    sha256 cellar: :any,                 arm64_ventura:  "6c97cd4a2d62cff63e286344f64708602c1f3608e7aeb5cb1b4c0b6c7379b9db"
    sha256 cellar: :any,                 arm64_monterey: "37bd3c433774da3be3911060587c1a5cfa44c5465c7174664d99f36cb0a7f92d"
    sha256 cellar: :any,                 sonoma:         "6d20f05f1eb9e9a266787e770f748eed7cc591740ad24c284b09ca15bcc8da35"
    sha256 cellar: :any,                 ventura:        "8554985b547b24d5e0f39fc9a80e53400aeb207e2a6255efbd4e1c037af042d4"
    sha256 cellar: :any,                 monterey:       "b963662ccd118e8cb12f57b4f76c30bbbc6b3755cf4aee71a56e8a27b6ed53fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f7f55108299fdf377ad7a5db0bf2f0854ce192f23aad35b08232cbbb2d5c413"
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

    # Use C++17 for compatibility with ceres-solver >= 2.2.0.
    # Issue ref: https:github.comcolmapcolmapissues2247
    inreplace "srcCMakeLists.txt", "-std=c++14", "-std=c++17"

    system "cmake", "-S", ".", "-B", "build", "-DCUDA_ENABLED=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}colmap", "database_creator", "--database_path", (testpath  "db")
    assert_path_exists (testpath  "db")
  end
end