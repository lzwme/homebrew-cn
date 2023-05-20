class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/6.1.0/libxc-6.1.0.tar.bz2"
  sha256 "04dcfbdb89ab0d9ae05d8534c46edf4f9ba60dd6b7633ce72f6cb3c9773bb344"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ada5e03bcd73422dca8fd176801f5dec75d892b02c70b9bd0dc64388036d4f86"
    sha256 cellar: :any,                 arm64_monterey: "ad8cf4c12bbccad4ac2601ec1ed34f18bcaa34470f8cd0fb5d5543b8b13878c0"
    sha256 cellar: :any,                 arm64_big_sur:  "86931b29ee7e9c1e17bd63a148f581186a7032e370125bed8539236930bfd63a"
    sha256 cellar: :any,                 ventura:        "b4b0c05e12b1ac3082ea9ee7bf9d7c34ae0634e13d8afa13dc8efecdbe65be81"
    sha256 cellar: :any,                 monterey:       "2df2ac59256d66177a9d45751f0740b39e3b33bda49789c3085ec758380a488b"
    sha256 cellar: :any,                 big_sur:        "2f22964420dbdd122b50c39d24d7c2e48933c88c0572eb3aadd30f5d9e78ee43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a02aa7e2e8cbf80689337ead9b89c6342baeabb092445a02f62f2bb4a260ca37"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_FORTRAN=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Common test files for both cmake and plain
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf("%d.%d.%d", major, minor, micro);
      }
    EOS
    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f03_lib_m
      end program lxctest
    EOS
    # Simple cmake example
    (testpath / "CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.6)
      project(test_libxc LANGUAGES C Fortran)
      find_package(Libxc CONFIG REQUIRED)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Libxc::xc)
      add_executable(test_fortran test.f90)
      target_link_libraries(test_fortran PRIVATE Libxc::xcf03)
    EOS
    # Test cmake build
    system "cmake", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test_c"
    system "./build/test_fortran"
    # Test compilers directly
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxc", "-o", "ctest", "-lm"
    system "./ctest"
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}",
                       "-o", "ftest"
    system "./ftest"
  end
end