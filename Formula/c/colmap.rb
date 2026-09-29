class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/4.2.0.tar.gz"
  sha256 "b61731fb1a4a33609e64fb353fe589d483be6a73878a5965b7d32ae23fb22fc5"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "42dae71a47e3ad16bad8b39f5146404575ca60d842dc3de5ac844914d9b1fdad"
    sha256 cellar: :any, arm64_tahoe:       "514c90bd545dcb09269710ecd4d39db422054914aba7812dac4b7d8c3be3e673"
    sha256 cellar: :any, arm64_sequoia:     "9b4b6c75345a1b333706358bf27eadcbd81ca67b7cfd92827e07dc9a350f9750"
    sha256 cellar: :any, arm64_linux:       "5b67705ec4b7f73f622f2081db6ed3fdd6664c58ffc0d9761154ecda1268315f"
    sha256 cellar: :any, x86_64_linux:      "ae6ff1aae2728eb4a021f16cb7de44871f77935bfcb6ae66f86adf4f3eeb45d8"
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