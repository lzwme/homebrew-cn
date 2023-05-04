class Hdf5Mpi < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.14/hdf5-1.14.0/src/hdf5-1.14.0.tar.bz2"
  sha256 "e4e79433450edae2865a4c6328188bb45391b29d74f8c538ee699f0b116c2ba0"
  license "BSD-3-Clause"
  version_scheme 1

  livecheck do
    formula "hdf5"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "02d20fa98336be4134b90c15b7786b39500788a21d6c9e725ede2d728bcea30e"
    sha256 cellar: :any,                 arm64_monterey: "5b0e278f6af3f0dc46ecd89b3ead4f11fad4d8415ce033563e3c1e2332eb3f15"
    sha256 cellar: :any,                 arm64_big_sur:  "79c6fd42e32de8c6fec3b01d9b51420461109c922c4ec098d6e655dc8724c896"
    sha256 cellar: :any,                 ventura:        "896e222c32614d85c6763778e801b858676551f21ea685dd985f8d45f3e3fbd6"
    sha256 cellar: :any,                 monterey:       "44501aba330e7c38a88103fe126e437db4fbc14fa16d20e8222f6ee84b9380be"
    sha256 cellar: :any,                 big_sur:        "7fe749b822371e649cba4d67624b2e50494218551b4384fb6b65c85326e008ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fe45112da259d0a8b5c6d586941a9937337ea118c4a7d8711923f5f4b518f53"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "open-mpi"

  uses_from_macos "zlib"

  conflicts_with "hdf5", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  # Fixes buildpath references in install, remove in next release
  # https://github.com/HDFGroup/hdf5/commit/02c68739745887cd17b840a7e91d2ec9c9008bb1
  patch :DATA

  def install
    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in bin/h5cc.in],
              "${libdir}/libhdf5.settings",
              "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am",
              "settingsdir=$(libdir)",
              "settingsdir=#{pkgshare}"

    if OS.mac?
      system "autoreconf", "--force", "--install", "--verbose"
    else
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-build-mode=production
      --enable-fortran
      --enable-parallel
      --prefix=#{prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
      CC=mpicc
      CXX=mpic++
      FC=mpifort
      F77=mpif77
      F90=mpif90
    ]
    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "hdf5.h"
      int main()
      {
        printf("%d.%d.%d\\n", H5_VERS_MAJOR, H5_VERS_MINOR, H5_VERS_RELEASE);
        return 0;
      }
    EOS
    system "#{bin}/h5pcc", "test.c"
    assert_equal version.to_s, shell_output("./a.out").chomp

    (testpath/"test.f90").write <<~EOS
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
    EOS
    system "#{bin}/h5pfc", "test.f90"
    assert_equal version.to_s, shell_output("./a.out").chomp
  end
end
__END__
diff --git a/configure.ac b/configure.ac
index 8e406f71af..7b1d10c014 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3012,8 +3012,7 @@ SUBFILING_VFD=no
 HAVE_MERCURY="no"
 
 ## Always include subfiling directory so public header files are available
-CPPFLAGS="$CPPFLAGS -I$ac_abs_confdir/src/H5FDsubfiling"
-AM_CPPFLAGS="$AM_CPPFLAGS -I$ac_abs_confdir/src/H5FDsubfiling"
+H5_CPPFLAGS="$H5_CPPFLAGS -I$ac_abs_confdir/src/H5FDsubfiling"
 
 AC_MSG_CHECKING([if the subfiling I/O virtual file driver (VFD) is enabled])
 
@@ -3061,8 +3060,7 @@ if test "X$SUBFILING_VFD" = "Xyes"; then
     mercury_dir="$ac_abs_confdir/src/H5FDsubfiling/mercury"
     mercury_inc="$mercury_dir/src/util"
 
-    CPPFLAGS="$CPPFLAGS -I$mercury_inc"
-    AM_CPPFLAGS="$AM_CPPFLAGS -I$mercury_inc"
+    H5_CPPFLAGS="$H5_CPPFLAGS -I$mercury_inc"
 
     HAVE_STDATOMIC_H="yes"
     AC_CHECK_HEADERS([stdatomic.h],,[HAVE_STDATOMIC_H="no"])