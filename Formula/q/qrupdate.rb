class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng"
  url "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng/-/archive/v1.3.0/qrupdate-ng-v1.3.0.tar.bz2"
  sha256 "a9bfa9b7dba580859babd89d04e31cfd289e7536b387c17be73bb5d1179273c4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8de0c15f142b19be3831da75bb4d4ac7ba43d6b4144da6590f0c1cc484e0d702"
    sha256 cellar: :any, arm64_tahoe:       "1a4ca84219584ba2ec5003c186d1cf09766b31042db215095b7a26c4b1314c96"
    sha256 cellar: :any, arm64_sequoia:     "79d72c81b79cd10559d03a868c1aa060f138e45406a5cbe13b6c2977cb30d780"
    sha256 cellar: :any, arm64_linux:       "4a4e8b69827605c9ea7ffe0af429f115a5245be335330ba7b1ddf78d81634125"
    sha256 cellar: :any, x86_64_linux:      "d48ab978930aab7ca3186597dd05a4fc5e1593f06430d68fd85076533f527205"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  deny_network_access!

  def install
    ENV.fortran

    # CMake's Fortran/C interface probe requires matching GCC LTO versions.
    ENV.method("gcc-#{Formula["gcc"].version.major}").call if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/tch1dn.f90", "test/utils.f90"
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"tch1dn.f90", pkgshare/"utils.f90",
                       "-fallow-argument-mismatch",
                       "-I#{include}/qrupdate",
                       "-L#{lib}", "-lqrupdate",
                       "-L#{formula_opt_lib("openblas")}", "-lopenblas"
    assert_match "PASSED   4     FAILED   0", shell_output("./test")
  end
end