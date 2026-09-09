class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/4.2.0.tar.gz"
  sha256 "b61731fb1a4a33609e64fb353fe589d483be6a73878a5965b7d32ae23fb22fc5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eb8d2a55cb9b3c5ebd902bd657f389dd8ba5ce4dbceb206ac12045ca505d831f"
    sha256 cellar: :any, arm64_sequoia: "ed9eabf3bc0048d8ee7edc2d29fe806bf3edce9f3ac983dd831608838c8fa613"
    sha256 cellar: :any, arm64_sonoma:  "7eff20ee06cede84fccf69a7b062f7b8e190d7c2e587af54f51a9720c0cf0dda"
    sha256 cellar: :any, arm64_linux:   "50c30b1a4c10831f83a4795c4e10c7be8faa8412b1c5f6d153914bdc739f7726"
    sha256 cellar: :any, x86_64_linux:  "bc0a16c0c18bc49b79abd56b4348e31afc22f9ef9a468d8f6beaae089d803e70"
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