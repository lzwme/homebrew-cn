class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/4.2.1.tar.gz"
  sha256 "15fb9e333541676e4ee9bc5d8ab95a3ed6e549a20eb13fc5aafd04ca06c76c88"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e17b6b14d674c6a34dc32b609aef9bd5d57e69191a5c3e5ae9d57508c4bb4ef2"
    sha256 cellar: :any, arm64_tahoe:       "8be46148b54419b50b0b861c56175ecc250ee19766dd160883f7354f210f4278"
    sha256 cellar: :any, arm64_sequoia:     "1836ed5530d63d5fd4405cb8cfee147277d42678dfb3e4332b08babaf147f9ad"
    sha256 cellar: :any, arm64_linux:       "64f50dc3bfe4249a41144bfd734734a1413b2342452e727c1f3ba933aae75340"
    sha256 cellar: :any, x86_64_linux:      "f4ff0edde8ea5f0d13e73f190d61c689dfa49c7af9173f377841c52a7d991b0d"
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
  depends_on "openssl@4"
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

  deny_network_access!

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
    args << "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"colmap", "database_creator", "--database_path", (testpath / "db")
    assert_path_exists (testpath / "db")
  end
end