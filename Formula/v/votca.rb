class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https:www.votca.org"
  url "https:github.comvotcavotcaarchiverefstagsv2023.tar.gz"
  sha256 "ac78d2eb5a6694b76878d2ab1ec86bb161765143a447cc23905cdcb2bb6743be"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1514b7dbb172def8b8b4f2a8d33da4f0063ea4ca7b56be0a73aa1e137f66179e"
    sha256 cellar: :any,                 arm64_ventura:  "7167d39d002e10d547cd5773c14185961fe7e7ce8ced06ec6cf28d227fa26a20"
    sha256 cellar: :any,                 arm64_monterey: "300dd0a80c49a7f93a3a853397a5ae8a16e0e84886699216823956eb296a9ab6"
    sha256 cellar: :any,                 sonoma:         "912246de3be6a8bdbf987ca228d084cecabb74af5774fd2f44374bbb059012c2"
    sha256 cellar: :any,                 ventura:        "39ca48d5c50b6957ae3c0fe73753c56caf994c84c69a541571ed52457c6a88bf"
    sha256 cellar: :any,                 monterey:       "4bd530f0e2150118a45d10023115d0766beee69dea307b9cfb6e14ee156bbd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "492af596e4b89036184d82b426b4034d71895421adc23f1c1f235161a430eff4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  # add gromacs dep back once it was built with clang
  # Use hdf5@1.10: Unable to determine HDF5 CXX flags from HDF5 wrapper.
  depends_on "hdf5@1.10"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"
  depends_on "numpy"
  depends_on "python@3.11"

  uses_from_macos "expat"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = [
      "-DINSTALL_RC_FILES=OFF",
      "-DINSTALL_CSGAPPS=ON",
      "-DBUILD_XTP=ON",
      "-DCMAKE_DISABLE_FIND_PACKAGE_GROMACS=ON",
      "-DENABLE_RPATH_INJECT=ON",
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}csg_property", "--help"
    (testpath"table.in").write <<~EOS
      0 0 i
      1 1 i
    EOS
    system "#{bin}csg_resample", "--in", "table.in", "--out", "table.out", "--grid", "0:0.1:1", "--type", "linear"
    assert_path_exists "#{testpath}table.out"
  end
end