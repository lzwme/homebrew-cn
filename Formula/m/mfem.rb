class Mfem < Formula
  desc "Free, lightweight, scalable C++ library for FEM"
  homepage "https:mfem.org"
  url "https:github.commfemmfemarchiverefstagsv4.8.tar.gz"
  sha256 "65472f732d273832c64b2c39460649dd862df674222c71bfa82cf2da76705052"
  license "BSD-3-Clause"
  head "https:github.commfemmfem.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e9c3599701802b5f1fe3c2e8fcd933dbec04f03adc247b1f2e438545dac1e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66b1e7f21b8baa4524495b5fdd9418081f0db55d935697164e486ed0a730eb1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e1de7199a836c46ec439fc0f1d5617cfa2f760407c1c24ae87cd9a488c64367"
    sha256 cellar: :any_skip_relocation, sonoma:        "89e928432924db722ffdf9662d6603529879e1c0772b5b732eae23da819abf56"
    sha256 cellar: :any_skip_relocation, ventura:       "1e43c80cef99645d02450848774f812ba9978f72302b4eaa1c96d0adadf25a55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd00cc4e92a1d4565fd1014d93d1fbff1405e381e7e308f9737cbfe05cdd7650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c35e1927d2e7ebe08eab48bfe60551a05d4138b1d89d743269216ea304664674"
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
    cp_r pkgshare"examples", testpath
    cp pkgshare"datastar.mesh", testpath"examples"
    system "make", "-C", testpath"examples", "all", "MFEM_INSTALL_DIR=#{prefix}", "CONFIG_MK=#{pkgshare}config.mk"
    args = ["-m", testpath"examplesstar.mesh", "--no-visualization"]
    system testpath"examplesex1", *args
    system "mpirun", "-np", "1", testpath"examplesex1p", *args
  end
end