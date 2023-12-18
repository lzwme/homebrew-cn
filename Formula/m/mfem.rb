class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "http:www.mfem.org"
  url "https:github.commfemmfemarchiverefstagsv4.6.tar.gz"
  sha256 "250bb6aa0fd5f6a6002c072d357656241ed38acfc750e43e87d8c36a8f8a4b4f"
  license "BSD-3-Clause"
  revision 1
  head "https:github.commfemmfem.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62ff9733940e031a023deaba54716e3800d9ed9187d21e10407a15c7ea69a584"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f1e1b59d02c77596d197c89a2871e23b0b9049791b2ea2a5b90926a4d896f34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d029b6df96209a1fa21b25fc316375f0ab579e6f98abbbd4b51e04296d7c4669"
    sha256 cellar: :any_skip_relocation, sonoma:         "47f92f4c919705628ebd66af6f37ca796fa29093a27220fc5343594be8f9279f"
    sha256 cellar: :any_skip_relocation, ventura:        "969ce230ca46647d1a2ae906f22ad906ef4d9c7cb336712489defb8476de97cd"
    sha256 cellar: :any_skip_relocation, monterey:       "9a68a845acc55b825a4fe7c26260d864e8477c35e500e9ce8ea94f9655ed9877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415a1c62d6854e17058a8db000ef97a62da5f0c4b5823146400391869706dce6"
  end

  depends_on "cmake" => :build
  depends_on "hypre"        # optional "mpi"
  depends_on "metis"        # optional "metis"
  depends_on "openblas"
  depends_on "suite-sparse"

  def install
    # fix `libcmakemfemMFEMConfig.cmake` file audit failure
    inreplace "configcmakeMFEMConfig.cmake.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    # fix `sharemfemconfig.mk` file audit failure
    inreplace "configconfig.mk.in", "@MFEM_CXX@", ENV.cxx
    inreplace "configconfig.mk.in", "@MFEM_HOST_CXX@", ENV.cxx

    args = [
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
    cp_r pkgshare"examples", testpath
    cp pkgshare"datastar.mesh", testpath"examples"
    system "make", "-C", testpath"examples", "all", "MFEM_INSTALL_DIR=#{prefix}", "CONFIG_MK=#{pkgshare}config.mk"
    args = ["-m", testpath"examplesstar.mesh", "--no-visualization"]
    system testpath"examplesex1", *args
    system "mpirun", "-np", "1", testpath"examplesex1p", *args
  end
end