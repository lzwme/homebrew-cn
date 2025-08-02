class Pnetcdf < Formula
  desc "Parallel netCDF library for scientific data using the OpenMPI library"
  homepage "https://parallel-netcdf.github.io/index.html"
  url "https://parallel-netcdf.github.io/Release/pnetcdf-1.14.1.tar.gz"
  sha256 "ffb5ee9bb40e4e5f09f1ed6b2eaa94c4e4810ce00111c29b5024cf91486d3fed"
  license "NetCDF"

  livecheck do
    url "https://parallel-netcdf.github.io/wiki/Download.html"
    regex(/href=.*?pnetcdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "7c40c27fb8668ad2e0aeba8a0a8c88ad7b62585af1e28d395b0a0fe2869728fb"
    sha256 arm64_sonoma:  "6aa771fed2f799f7f3f7754344570cbdd0e2fb06019d03ade0979279da7a67b4"
    sha256 arm64_ventura: "b55307d959eb56298ae7582355547ad148f3ebed3785eb29b309375452721128"
    sha256 sonoma:        "3c2995b0e78ea6ee429308bcf2f5b30963c105d4ee9cc45a32a43a610d02ea0e"
    sha256 ventura:       "0a20d95e7a6ba0181221d08838c550c63126f2ba9455319205e4ac01960e695e"
    sha256 x86_64_linux:  "efe3836973413970bcd6e065d38972abf8c4dccdac993fa91fc40ede744d0112"
  end

  depends_on "gcc"
  depends_on "open-mpi"

  uses_from_macos "m4" => :build

  def install
    # Work around asm incompatibility with new linker (FB13194320)
    # https://github.com/Parallel-NetCDF/PnetCDF/issues/139
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-shared"

    system "make", "install"
  end

  # These tests were converted from the netcdf formula.
  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "pnetcdf.h"
      int main()
      {
        printf(PNETCDF_VERSION);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lpnetcdf",
                   "-o", "test"
    assert_equal `./test`, version.to_s

    (testpath/"test.f90").write <<~FORTRAN
      program test
        use mpi
        use pnetcdf
        integer :: ncid, varid, dimids(2), ierr
        integer :: dat(2,2) = reshape([1, 2, 3, 4], [2, 2])
        call mpi_init(ierr)
        call check( nfmpi_create(MPI_COMM_WORLD, "test.nc", NF_CLOBBER, MPI_INFO_NULL, ncid) )
        call check( nfmpi_def_dim(ncid, "x", 2_MPI_OFFSET_KIND, dimids(2)) )
        call check( nfmpi_def_dim(ncid, "y", 2_MPI_OFFSET_KIND, dimids(1)) )
        call check( nfmpi_def_var(ncid, "data", NF_INT, 2, dimids, varid) )
        call check( nfmpi_enddef(ncid) )
        call check( nfmpi_put_var_int_all(ncid, varid, dat) )
        call check( nfmpi_close(ncid) )
        call mpi_finalize(ierr)
      contains
        subroutine check(status)
          integer, intent(in) :: status
          if (status /= nf_noerr) call abort
        end subroutine check
      end program test
    FORTRAN
    system "mpif90", "test.f90", "-L#{lib}", "-I#{include}", "-lpnetcdf",
                       "-o", "testf"
    system "./testf"
  end
end