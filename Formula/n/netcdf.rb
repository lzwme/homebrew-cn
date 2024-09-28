class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https:www.unidata.ucar.edusoftwarenetcdf"
  url "https:github.comUnidatanetcdf-carchiverefstagsv4.9.2.tar.gz"
  sha256 "bc104d101278c68b303359b3dc4192f81592ae8640f1aee486921138f7f88cb7"
  license "BSD-3-Clause"
  revision 2
  head "https:github.comUnidatanetcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "016f4defbc70f7932c40c75671487b35221e30519b2c1f16983db14573b65f6a"
    sha256 cellar: :any,                 arm64_sonoma:  "e1e3c2b95509a7b7ff02ea59a6c9fbce906dbab8a310c771df782d1b1b1e6cfc"
    sha256 cellar: :any,                 arm64_ventura: "dca2073eafc069fbc52a1a0c4c60aefd1e43e921dcda35474ea84696519bf482"
    sha256 cellar: :any,                 sonoma:        "b8072f889abbd500fd7219d6c25bf83c727f783a9df124c695919ce61bfedb6a"
    sha256 cellar: :any,                 ventura:       "4e6a2e031559d64f3d1f0bed7e970e5802d85413251281ee50e27826c3ec14b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf90052e1c43052e67c31b8c79636eaffa666c60ba86064713c3f704e9774cc7"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "m4" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "zstd"
  end

  def install
    args = %w[-DENABLE_TESTS=OFF -DENABLE_NETCDF_4=ON -DENABLE_DOXYGEN=OFF]
    # Fixes "relocation R_X86_64_PC32 against symbol `stderr@@GLIBC_2.2.5' can not be used" on Linux
    args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install "build_staticlibliblibnetcdf.a"

    # Remove shim paths
    inreplace [bin"nc-config", lib"pkgconfignetcdf.pc", lib"cmakenetCDFnetCDFConfig.cmake",
               lib"libnetcdf.settings"], Superenv.shims_pathENV.cc, ENV.cc

    # Fix bad flags, breaks vtk build
    # https:github.comHomebrewhomebrew-corepull170959#discussion_r1744656193
    inreplace lib"cmakenetCDFnetCDFTargets.cmake", "hdf5_hl-shared;hdf5-shared;", "hdf5_hl;hdf5;"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include "netcdf_meta.h"
      int main()
      {
        printf(NC_VERSION);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lnetcdf",
                   "-o", "test"
    assert_equal version.to_s, `.test`
  end
end