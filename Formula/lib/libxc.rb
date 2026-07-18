class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://libxc.gitlab.io/"
  url "https://gitlab.com/libxc/libxc/-/archive/7.1.0/libxc-7.1.0.tar.bz2"
  sha256 "30f742fc4ec917d386ae199688ad1b02381d1494d03196dffcf1e03b3c026a68"
  license "MPL-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bda72696a6eda5f242f54ee7c75d1e6830077c698ec823f90fe2c3c93a3c424a"
    sha256 cellar: :any, arm64_sequoia: "70362836c1e7529240f1cce19b5d7a24956991f9e135236e3e7c0713f6936d27"
    sha256 cellar: :any, arm64_sonoma:  "50e87883d16f5d71fd1f9ef152a19e364b82334fd2d590c4e798806c3c0cd17e"
    sha256 cellar: :any, sonoma:        "8bb9921f7e1eba36f47ea2d29144866e2e83efb2ceaf426dbfe9a198b74df055"
    sha256 cellar: :any, arm64_linux:   "ce28f78673e13bf0b4d394deb2e0446730910f6b1cf6bcb5bbde5bb82b9b80fb"
    sha256 cellar: :any, x86_64_linux:  "45b0c8db283510fd66a12271a2efa017a7d3f02e9622d92cc20c9efa9cdc8020"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    args = %w[
      -DENABLE_FORTRAN=ON
      -DDISABLE_KXC=OFF
      -DDISABLE_LXC=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Common test files for both cmake and plain
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf("%d.%d.%d", major, minor, micro);
      }
    C
    (testpath/"test.f90").write <<~FORTRAN
      program lxctest
        use xc_f03_lib_m
      end program lxctest
    FORTRAN
    # Simple cmake example
    (testpath / "CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.6)
      project(test_libxc LANGUAGES C Fortran)
      find_package(Libxc CONFIG REQUIRED)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Libxc::xc)
      add_executable(test_fortran test.f90)
      target_link_libraries(test_fortran PRIVATE Libxc::xcf03)
    CMAKE
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