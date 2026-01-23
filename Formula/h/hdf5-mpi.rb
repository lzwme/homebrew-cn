class Hdf5Mpi < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/solutions/hdf5/"
  url "https://ghfast.top/https://github.com/HDFGroup/hdf5/releases/download/2.0.0/hdf5-2.0.0.tar.gz"
  sha256 "f4c2edc5668fb846627182708dbe1e16c60c467e63177a75b0b9f12c19d7efed"
  license "BSD-3-Clause"
  version_scheme 1

  livecheck do
    formula "hdf5"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "caf2dbe3e96d3e7ed4f8457fbc4b11786c7529e2dd70cbb7ec941f8bfc6dfe7f"
    sha256 cellar: :any,                 arm64_sequoia: "53fcc73745c194a5fac3e1f1e7173de981c70dffae569a0c9cd68507c0d478fe"
    sha256 cellar: :any,                 arm64_sonoma:  "e9309fccc7350411d7548fe88c0deb09f50062e1f3900bb0eac4b99542a1bcdc"
    sha256 cellar: :any,                 sonoma:        "717e830e7379dbd12d506c7c3a0bfe00ef4349ba29c9ccea9044cf7e06b31c53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36474a3ff7fc0e0aec844374fb2f738c9a4d8657c10bd19d2d46a4e1c17243ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff89895ec5e2f43e0c1eaddcdca76aadc61f9b5b61519d945df29d734d509e7a"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "open-mpi"
  depends_on "pkgconf"

  uses_from_macos "zlib"

  conflicts_with "hdf5", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  def install
    # CMake FortranCInterface_VERIFY fails with LTO on Linux due to different GCC and GFortran versions
    ENV.append "FFLAGS", "-fno-lto" if OS.linux?

    args = %w[
      -DCMAKE_C_COMPILER=mpicc
      -DCMAKE_CXX_COMPILER=mpicxx
      -DCMAKE_Fortran_COMPILER=mpif90
      -DHDF5_USE_GNU_DIRS:BOOL=ON
      -DHDF5_INSTALL_CMAKE_DIR=lib/cmake/hdf5
      -DHDF5_ENABLE_PARALLEL:BOOL=ON
      -DHDF5_ALLOW_UNSUPPORTED:BOOL=ON
      -DHDF5_BUILD_FORTRAN:BOOL=ON
      -DHDF5_BUILD_CPP_LIB:BOOL=ON
      -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=ON
      -DHDF5_ENABLE_ZLIB_SUPPORT:BOOL=ON
    ]

    # https://github.com/HDFGroup/hdf5/issues/4310
    args << "-DHDF5_ENABLE_NONSTANDARD_FEATURE_FLOAT16:BOOL=OFF"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "hdf5.h"
      int main()
      {
        printf("%d.%d.%d\\n", H5_VERS_MAJOR, H5_VERS_MINOR, H5_VERS_RELEASE);
        return 0;
      }
    C
    system bin/"h5pcc", "test.c"
    assert_equal version.major_minor_patch.to_s, shell_output("./a.out").chomp

    (testpath/"test.f90").write <<~FORTRAN
      use hdf5
      integer(hid_t) :: f, dspace, dset
      integer(hsize_t), dimension(2) :: dims = [2, 2]
      integer :: error = 0, major, minor, rel

      call h5open_f (error)
      if (error /= 0) call abort
      call h5fcreate_f ("test.h5", H5F_ACC_TRUNC_F, f, error)
      if (error /= 0) call abort
      call h5screate_simple_f (2, dims, dspace, error)
      if (error /= 0) call abort
      call h5dcreate_f (f, "data", H5T_NATIVE_INTEGER, dspace, dset, error)
      if (error /= 0) call abort
      call h5dclose_f (dset, error)
      if (error /= 0) call abort
      call h5sclose_f (dspace, error)
      if (error /= 0) call abort
      call h5fclose_f (f, error)
      if (error /= 0) call abort
      call h5close_f (error)
      if (error /= 0) call abort
      CALL h5get_libversion_f (major, minor, rel, error)
      if (error /= 0) call abort
      write (*,"(I0,'.',I0,'.',I0)") major, minor, rel
      end
    FORTRAN
    system bin/"h5pfc", "test.f90"
    assert_equal version.major_minor_patch.to_s, shell_output("./a.out").chomp

    # Make sure that it was built with SZIP/libaec
    config = shell_output("#{bin}/h5cc -showconfig")
    assert_match %r{I/O filters.*DECODE}, config
  end
end