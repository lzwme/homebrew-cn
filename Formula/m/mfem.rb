class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "https://mfem.org/"
  url "https://ghfast.top/https://github.com/mfem/mfem/archive/refs/tags/v4.9.tar.gz"
  sha256 "ea3ac13e182c09f05b414b03a9bef7a4da99d45d67ee409112b8f11058447a7c"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/mfem/mfem.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ab9af5e6f8c9ca0520522c9473fb955d07d2c2962e69f8537f43f258260f7e9b"
    sha256 cellar: :any, arm64_sequoia: "57f599adc593f46f61c7cf576f2d1e0fb2cf4c9660d3d5863c13f5f93ada8782"
    sha256 cellar: :any, arm64_sonoma:  "c20b72b640ef303949fcc34f56598a14a5f34142d3cdfa71a480660c5b941b94"
    sha256 cellar: :any, sonoma:        "4c5dd871cf6993bd2d3757751de00a4d5fcc8b38fefd6c6753c79380f1777bc2"
    sha256 cellar: :any, arm64_linux:   "dd6f4d151c1ae7b5ce3274d450afa37e74cb4d8580af46fc24f4c1f89647e8ae"
    sha256 cellar: :any, x86_64_linux:  "ab64368a4f7f0be0acb93072e9efed189bdad87c4446e6cc20df60f8e1e1ee9b"
  end

  depends_on "cmake" => :build
  depends_on "hypre"        # optional "mpi"
  depends_on "metis"        # optional "metis"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  def install
    # fix `lib/cmake/mfem/MFEMConfig.cmake` file audit failure
    inreplace "config/cmake/MFEMConfig.cmake.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    # fix `share/mfem/config.mk` file audit failure
    inreplace "config/config.mk.in", "@MFEM_CXX@", ENV.cxx
    inreplace "config/config.mk.in", "@MFEM_HOST_CXX@", ENV.cxx

    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DMFEM_USE_MPI=YES",
      "-DMFEM_USE_METIS_5=YES",
      "-DMFEM_USE_SUITESPARSE=YES",
      "-DMFEM_USE_NETCDF=NO",
      "-DMFEM_USE_SUPERLU=NO",
    ]
    args << "-DMFEM_USE_LAPACK=YES" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples", "data"
  end

  test do
    cp_r pkgshare/"examples", testpath
    cp pkgshare/"data/star.mesh", testpath/"examples"
    system "make", "-C", testpath/"examples", "all", "MFEM_INSTALL_DIR=#{prefix}", "CONFIG_MK=#{pkgshare}/config.mk"
    args = ["-m", testpath/"examples/star.mesh", "--no-visualization"]
    system testpath/"examples/ex1", *args
    system "mpirun", "-np", "1", testpath/"examples/ex1p", *args
  end
end