class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/4.2.1.tar.gz"
  sha256 "15fb9e333541676e4ee9bc5d8ab95a3ed6e549a20eb13fc5aafd04ca06c76c88"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c409e9a23becb7d06c1e95c2b13ff72db84ce57b9add93c51edb507d5b092074"
    sha256 cellar: :any, arm64_tahoe:       "d1de63a50011e06f7703c62e099bdd238ce19cae490bf83f721c5b5ccbb75410"
    sha256 cellar: :any, arm64_sequoia:     "fcbb384bf9b1a0d01a56ca3567a0af4dabe121391992fae6f0416e1a2e9ca06d"
    sha256 cellar: :any, arm64_linux:       "539a35873f7170dbb9ae8f4474762bf76c7a080576e46bd59dc1a11851f81750"
    sha256 cellar: :any, x86_64_linux:      "453cca671454c37bc7b517d58cda21c282f03d226a1f13c2e705865d10cf3926"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "ceres-solver"
  depends_on "cgal"
  depends_on "eigen" => :no_linkage
  depends_on "faiss"
  depends_on "flann"
  depends_on "gflags"
  depends_on "glew"
  depends_on "glog"
  depends_on "gmp"
  depends_on "lz4"
  depends_on "metis"
  depends_on "mpfr"
  depends_on "onnx"
  depends_on "onnxruntime"
  depends_on "openimageio"
  depends_on "openssl@3"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "suite-sparse"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "libomp"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "mesa"
  end

  # TODO: Restore the poselib dependency when a release includes the required solvers.
  # Release tracking: https://github.com/PoseLib/PoseLib/issues/180
  # Required solver: https://github.com/PoseLib/PoseLib/pull/208
  resource "poselib" do
    url "https://ghfast.top/https://github.com/PoseLib/PoseLib/archive/fa7280fee27f97aff31ae7f98bab7f583fac7d08.tar.gz"
    sha256 "ff1c44342ab2c84ac9ac74c4028762c50d12ab5a483d20466cc1f635fe8f4d1f"
  end

  def install
    resource("poselib").stage do
      system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON",
                      *std_cmake_args(install_prefix: libexec/"poselib")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Keep the private PoseLib available to consumers of COLMAP's CMake package.
    inreplace "cmake/colmap-config.cmake.in", "set(FETCH_POSELIB @FETCH_POSELIB@)",
              <<~CMAKE.chomp
                set(FETCH_POSELIB @FETCH_POSELIB@)
                set(PoseLib_DIR "${PACKAGE_PREFIX_DIR}/libexec/poselib/lib/cmake/PoseLib")
              CMAKE

    args = %w[
      -DCUDA_ENABLED=OFF
      -DFETCH_POSELIB=OFF
      -DFETCH_FAISS=OFF
      -DFETCH_ONNX=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    args << "-DPoseLib_DIR=#{libexec}/poselib/lib/cmake/PoseLib"

    # Fix library install directory and rpath
    inreplace "CMakeLists.txt", "LIBRARY DESTINATION thirdparty/", "LIBRARY DESTINATION lib/"
    args << "-DCMAKE_INSTALL_RPATH=#{loader_path};#{loader_path}/../libexec/poselib/lib"
    # Set openssl@3 to avoid indirect linkage with openssl@4
    # TODO: switch to openssl@4
    args << "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end