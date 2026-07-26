class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/4.1.1.tar.gz"
  sha256 "0cadd938756d7046055751ca35bcf0d35911403fcb65b91d022ddc418dc110a5"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256               arm64_tahoe:   "27c39cefba9302d37d3eede1d0501c64c53ea1e32760c0f392815f512f27496d"
    sha256               arm64_sequoia: "384b70e8d885e8503d649ee11ae4dfa70da6854f14502706cba05b78ec71201d"
    sha256               arm64_sonoma:  "d0f131eaf74c0c66d525a588204cac682c84ed7f99990f22d7fef128c3a55b92"
    sha256 cellar: :any, sonoma:        "cc9c44da4ae177dd6db4976665ed926dc25742f57df84647f2ad6af8111b5317"
    sha256 cellar: :any, arm64_linux:   "6c0e104651c475ca182c888652d632b3cdccfbf7fe470279a1a9cc8e281048d8"
    sha256 cellar: :any, x86_64_linux:  "70e9ba849073d9f0721ea0cdae8750107d31bc8c2398939a3d16fa5e09829ae3"
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
  depends_on "poselib"
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

  def install
    args = %w[
      -DCUDA_ENABLED=OFF
      -DFETCH_POSELIB=OFF
      -DFETCH_FAISS=OFF
      -DFETCH_ONNX=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    # Fix library install directory and rpath
    inreplace "CMakeLists.txt", "LIBRARY DESTINATION thirdparty/", "LIBRARY DESTINATION lib/"
    args << "-DCMAKE_INSTALL_RPATH=#{loader_path}"
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