class NetcdfFortran < Formula
  desc "Fortran libraries and utilities for NetCDF"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://ghproxy.com/https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "8194aa70e400c0adfc456127c1d97af2c6489207171d13b10cd754a16da8b0ca"
  license "NetCDF"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17546227dae175ccc6fae72d3868bb6a452150881840d15af9f105ad7076f4dd"
    sha256 cellar: :any,                 arm64_monterey: "134a5c5ea3b5d0759fbadf7e089c6a68a15e5921ec808694c9832be5eefe9ca6"
    sha256 cellar: :any,                 arm64_big_sur:  "7c2a2fcaf0b3d56b6b9d26b8ec06757762c856e141529ae18cdad55bf6f15956"
    sha256 cellar: :any,                 ventura:        "0c499d512aef14ff2c295ef28efa5fed59f9a54499ab78b705d4dfa9e223c0b6"
    sha256 cellar: :any,                 monterey:       "d38a0dfb6e6e37bafe1bac279c79647d1171bf64c15c47b8c604faaf20dca2b0"
    sha256 cellar: :any,                 big_sur:        "44789814252155aa8e8a13211917fa96ba099431b267b6064dcc1ef7f17c43c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84d1c029f741b96c5592a405fa362816b773d82cbb151f4d565192e0f8b68c8a"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"
  depends_on "netcdf"

  def install
    args = std_cmake_args + %w[-DBUILD_TESTING=OFF -DENABLE_TESTS=OFF -DENABLE_NETCDF_4=ON -DENABLE_DOXYGEN=OFF]

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/fortran/libnetcdff.a"

    # Remove shim paths
    inreplace [bin/"nf-config", lib/"libnetcdff.settings", lib/"pkgconfig/netcdf-fortran.pc"],
      Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    (testpath/"test.f90").write <<~EOS
      program test
        use netcdf
        integer :: ncid, varid, dimids(2)
        integer :: dat(2,2) = reshape([1, 2, 3, 4], [2, 2])
        call check( nf90_create("test.nc", NF90_CLOBBER, ncid) )
        call check( nf90_def_dim(ncid, "x", 2, dimids(2)) )
        call check( nf90_def_dim(ncid, "y", 2, dimids(1)) )
        call check( nf90_def_var(ncid, "data", NF90_INT, dimids, varid) )
        call check( nf90_enddef(ncid) )
        call check( nf90_put_var(ncid, varid, dat) )
        call check( nf90_close(ncid) )
      contains
        subroutine check(status)
          integer, intent(in) :: status
          if (status /= nf90_noerr) call abort
        end subroutine check
      end program test
    EOS
    system "gfortran", "test.f90", "-L#{lib}", "-I#{include}", "-lnetcdff",
                       "-o", "testf"
    system "./testf"
  end
end