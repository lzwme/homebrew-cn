class Sundials < Formula
  desc "Nonlinear and differentialalgebraic equations solver"
  homepage "https:computing.llnl.govprojectssundials"
  url "https:github.comLLNLsundialsreleasesdownloadv6.6.2sundials-6.6.2.tar.gz"
  sha256 "08f8223a5561327e44c072e46faa7f665c0c0bc8cd7e45d23f486c3d24c65009"
  license "BSD-3-Clause"

  livecheck do
    url "https:computing.llnl.govprojectssundialssundials-software"
    regex(href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2f3390dc51554b6502fc2389903fd1d5b91a79e4ab4f15015a091fcadcc980a4"
    sha256 cellar: :any,                 arm64_ventura:  "a7321b2b3453445aca8431544df06e5f1d3986cd8a672bbaf54ba14f24310e20"
    sha256 cellar: :any,                 arm64_monterey: "40f3c72236f6cac7afca54b2b73773f9b00e5cf8acb2d474dae4f6319f4585ed"
    sha256 cellar: :any,                 sonoma:         "33027ee26798e4c966059ca95b8f7a3e7921bb1d8063914fbb4e2face8319334"
    sha256 cellar: :any,                 ventura:        "90ee5103eed190baa3451306d9fb32096f654876b0410471a8b7d4f68dc20dd0"
    sha256 cellar: :any,                 monterey:       "e1a320afa5d96fa16fd08a6118337eed09a0c029111ae268e19824afd83c7ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dff61c5da4b195ffcd78fe70c9c50b2079e8afd01f416891e5606099fd47544"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  uses_from_macos "libpcap"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Only keep one example for testing purposes
    (pkgshare"examples").install Dir[prefix"examplesnvectorserial*"] \
                                  - Dir[prefix"examplesnvectorserial{CMake*,Makefile}"]
    (prefix"examples").rmtree
  end

  test do
    cp Dir[pkgshare"examples*"], testpath
    system ENV.cc, "test_nvector.c", "test_nvector_serial.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lsundials_nvecserial", "-lm"
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output(".test 42 0")
  end
end