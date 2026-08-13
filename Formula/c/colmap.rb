class Colmap < Formula
  desc "Structure-from-Motion and Multi-View Stereo"
  homepage "https://colmap.github.io/"
  url "https://ghfast.top/https://github.com/colmap/colmap/archive/refs/tags/4.1.1.tar.gz"
  sha256 "0cadd938756d7046055751ca35bcf0d35911403fcb65b91d022ddc418dc110a5"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256               arm64_tahoe:   "1ac7f7d96767da385c220dc3888b0ffa224f8f27e2f4026ff4231ad78b682869"
    sha256               arm64_sequoia: "b187521c6fb5e98e9eba4ee0e89e8912a6bfc9b8fb11c439b8031e25ec289f9d"
    sha256               arm64_sonoma:  "3126bca3f04c9cd26c6b069835599e8205512c4dd7f0b8fcd84c21e48d451386"
    sha256 cellar: :any, sonoma:        "676a71c29ce715dd3f215ca0df6972bf84f51aba0dad156c1381d25a348a7daf"
    sha256 cellar: :any, arm64_linux:   "5c352565389dc8b2119456a323eceb825cecbfb01db0223e64d95fa5de8c72e4"
    sha256 cellar: :any, x86_64_linux:  "1196b3eb118b4cbfd21cc06e0bb2f904d6af78b0676bc78c575c64f5940eb186"
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