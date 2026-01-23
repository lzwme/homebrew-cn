class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/solutions/hdf5/"
  url "https://ghfast.top/https://github.com/HDFGroup/hdf5/releases/download/2.0.0/hdf5-2.0.0.tar.gz"
  sha256 "f4c2edc5668fb846627182708dbe1e16c60c467e63177a75b0b9f12c19d7efed"
  license "BSD-3-Clause"
  version_scheme 1

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b0b7cbbfd0b4a5a7631c1b4a874e55216b6759eea361c9c9578dc5facaea4eee"
    sha256 cellar: :any,                 arm64_sequoia: "8ff4e4519419c163a9994e26c6efce4aac29b2b30559862a6788ae7680f38327"
    sha256 cellar: :any,                 arm64_sonoma:  "a8087eef9b98690fd7fff33d42ee5a7abbcfe1bca4473b9722f23a1a6ad0d789"
    sha256 cellar: :any,                 sonoma:        "cf5da64803d500ee0f1e7f270997f742615632dbce3268b7bc444cff4d680c33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee5802265ecad3b39a76995a9edfd5d583e72aeff7715c6a3c610ee3ec88cb3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8134b7bdd4cae67b32efd851769819415b886921263e24b0af93b0d536f8443e"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "libaec"
  depends_on "pkgconf"

  uses_from_macos "zlib"

  conflicts_with "hdf5-mpi", because: "hdf5-mpi is a variant of hdf5, one can only use one or the other"

  def install
    # Avoid c/c++ shims in settings files
    inreplace_c_files = %w[
      src/H5build_settings.cmake.c.in
      src/libhdf5.settings.in
    ]
    inreplace inreplace_c_files do |s|
      s.gsub! "@CMAKE_C_COMPILER@", ENV.cc
      s.gsub! "@CMAKE_CXX_COMPILER@", ENV.cxx
    end

    # CMake FortranCInterface_VERIFY fails with LTO on Linux due to different GCC and GFortran versions
    ENV.append "FFLAGS", "-fno-lto" if OS.linux?

    args = %W[
      -DHDF5_H5CC_C_COMPILER=#{ENV.cc}
      -DHDF5_H5CC_CXX_COMPILER=#{ENV.cxx}
      -DHDF5_USE_GNU_DIRS:BOOL=ON
      -DHDF5_INSTALL_CMAKE_DIR=lib/cmake/hdf5
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
    system bin/"h5cc", "test.c"
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
    system bin/"h5fc", "test.f90"
    assert_equal version.major_minor_patch.to_s, shell_output("./a.out").chomp

    # Make sure that it was built with SZIP/libaec
    config = shell_output("#{bin}/h5cc -showconfig")
    assert_match %r{I/O filters.*DECODE}, config
  end
end