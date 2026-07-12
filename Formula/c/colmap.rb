class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/4.1.0.tar.gz"
  sha256 "fc944df46ee9c213d4256cec30c085a6baa67256e7e6e0be63b13ea43ce9fcf7"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256               arm64_tahoe:   "294597cfc12ac5d91e0e7716494876d073a5d9896386e8353443763f3e5c5bd0"
    sha256               arm64_sequoia: "54a77d4d327ecd37fbd9ffde808511c03b82ee13b417c9fcf34baf40de16e8eb"
    sha256               arm64_sonoma:  "a034baa04880996812eff2e4799dd3e755b1d2758c3775bc60fa5778c6a09747"
    sha256 cellar: :any, sonoma:        "dd5ce4b804c4ad2133958877491184dd3bf0d2ad1079fe24ad85a53d22c37844"
    sha256 cellar: :any, arm64_linux:   "9eae66b2467c5fd43a39671c0e58759f485ec27f8f0316216fd8bd767f8a3f36"
    sha256 cellar: :any, x86_64_linux:  "bf20d86fecc4524c43d8f54827fc863475a04bef9a518818555abc657746d69f"
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