class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https:www.votca.org"
  url "https:github.comvotcavotcaarchiverefstagsv2024.1.tar.gz"
  sha256 "74d447f976a7d5c05ec65ab99f52b75379cafa3b40b8bc3b9b328f8402bc53dc"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "528f109aaeb4bad60365616e2ae9c69ba8520e40fc7b933ef05bdde967084266"
    sha256 cellar: :any,                 arm64_ventura:  "626419cb9f450f1e806c069e08f2177fdced2f4b8e97fa7b2417aa6d11544e3a"
    sha256 cellar: :any,                 arm64_monterey: "cd2e2b233adb416508c97793eae83959a50d773fa1d65feca4e7193d0678dcb7"
    sha256 cellar: :any,                 sonoma:         "5507f809c1f1a79bf0b9bdc7d6882a0993444a895421762059f8b003dfbc1674"
    sha256 cellar: :any,                 ventura:        "80036e2945f55198de413d036f9f4015866a92c0e26a2047c80b028db291bd21"
    sha256 cellar: :any,                 monterey:       "917f3a6638f494825e97ae96901127a7c2bdeb2f10344b7161661e9933b2c497"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0502b5382574920108db15990f74d79f40fe10eee13aeb7cdd1bb4808cb85265"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  depends_on "gcc" # for OpenMP
  # add gromacs dep back once it was built with clang
  depends_on "hdf5"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"
  depends_on "numpy"
  depends_on "python@3.12"

  uses_from_macos "expat"

  on_macos do
    depends_on "libaec"
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
    system bin"csg_property", "--help"
    (testpath"table.in").write <<~EOS
      0 0 i
      1 1 i
    EOS
    system bin"csg_resample", "--in", "table.in", "--out", "table.out", "--grid", "0:0.1:1", "--type", "linear"
    assert_path_exists "#{testpath}table.out"
  end
end