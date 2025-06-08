class Hdf5Mpi < Formula
  desc "File format designed to store large amounts of data"
  homepage "https:www.hdfgroup.orgsolutionshdf5"
  url "https:github.comHDFGrouphdf5releasesdownloadhdf5_1.14.6hdf5-1.14.6.tar.gz"
  sha256 "e4defbac30f50d64e1556374aa49e574417c9e72c6b1de7a4ff88c4b1bea6e9b"
  license "BSD-3-Clause"
  version_scheme 1

  livecheck do
    formula "hdf5"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3d151c2f7f4e990d4c87d09cfd1159a00eeced94110946b04d78e8afc643532d"
    sha256 cellar: :any,                 arm64_sonoma:  "328ef1d38510de4d0b6acdd2aa8ba2bf96ee37c7006ee56b7cf33107386a4eb3"
    sha256 cellar: :any,                 arm64_ventura: "ab720a1b8793cda7b0726ca973b97823986b14a01829b01532dc9ac27872851c"
    sha256 cellar: :any,                 sonoma:        "e33bdad2d726e495962a617bfe049532cbb7fe0b65cc7e023888c8b02028ddb3"
    sha256 cellar: :any,                 ventura:       "8a473329abf771f03d917727b158c734fc39e25a2dc11bd484d0b035ddd106c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a08338aebc175d621fe8d25c8ce7545228c8ed465e0f8e4f2b7af29a6abfe33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "effb5567624b9c92939a07d58a03c66710dec767d17b1e85f94a7ac94f1db18d"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "open-mpi"
  depends_on "pkgconf"

  uses_from_macos "zlib"

  conflicts_with "hdf5", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  def install
    args = %w[
      -DHDF5_USE_GNU_DIRS:BOOL=ON
      -DHDF5_INSTALL_CMAKE_DIR=libcmakehdf5
      -DHDF5_ENABLE_PARALLEL:BOOL=ON
      -DALLOW_UNSUPPORTED:BOOL=ON
      -DHDF5_BUILD_FORTRAN:BOOL=ON
      -DHDF5_BUILD_CPP_LIB:BOOL=ON
      -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=ON
    ]

    # https:github.comHDFGrouphdf5issues4310
    args << "-DHDF5_ENABLE_NONSTANDARD_FEATURE_FLOAT16:BOOL=OFF"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # Avoid c shims in settings files
    inreplace_c_files = %w[
      buildsrcH5build_settings.c
      buildsrclibhdf5.settings
    ]
    inreplace inreplace_c_files, Superenv.shims_pathENV.cc, ENV.cc

    # Avoid cpp shims in settings files
    inreplace_cxx_files = %w[
      buildCMakeFilesh5c++
      buildCMakeFilesh5hlc++
    ]
    inreplace_cxx_files << "buildsrclibhdf5.settings" if OS.linux?
    inreplace inreplace_cxx_files, Superenv.shims_pathENV.cxx, ENV.cxx

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdio.h>
      #include "hdf5.h"
      int main()
      {
        printf("%d.%d.%d\\n", H5_VERS_MAJOR, H5_VERS_MINOR, H5_VERS_RELEASE);
        return 0;
      }
    C
    system bin"h5pcc", "test.c"
    assert_equal version.major_minor_patch.to_s, shell_output(".a.out").chomp

    (testpath"test.f90").write <<~FORTRAN
      use hdf5
      integer(hid_t) :: f, dspace, dset
      integer(hsize_t), dimension(2) :: dims = [2, 2]
      integer :: error = 0, major, minor, rel

      call h5open_f (error)
      if (error = 0) call abort
      call h5fcreate_f ("test.h5", H5F_ACC_TRUNC_F, f, error)
      if (error = 0) call abort
      call h5screate_simple_f (2, dims, dspace, error)
      if (error = 0) call abort
      call h5dcreate_f (f, "data", H5T_NATIVE_INTEGER, dspace, dset, error)
      if (error = 0) call abort
      call h5dclose_f (dset, error)
      if (error = 0) call abort
      call h5sclose_f (dspace, error)
      if (error = 0) call abort
      call h5fclose_f (f, error)
      if (error = 0) call abort
      call h5close_f (error)
      if (error = 0) call abort
      CALL h5get_libversion_f (major, minor, rel, error)
      if (error = 0) call abort
      write (*,"(I0,'.',I0,'.',I0)") major, minor, rel
      end
    FORTRAN
    system bin"h5pfc", "test.f90"
    assert_equal version.major_minor_patch.to_s, shell_output(".a.out").chomp

    # Make sure that it was built with SZIPlibaec
    config = shell_output("#{bin}h5cc -showconfig")
    assert_match %r{IO filters.*DECODE}, config
  end
end