class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https:www.cp2k.org"
  url "https:github.comcp2kcp2kreleasesdownloadv2024.3cp2k-2024.3.tar.bz2"
  sha256 "a6eeee773b6b1fb417def576e4049a89a08a0ed5feffcd7f0b33c7d7b48f19ba"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "afcde06b0ad9e8670f2e03850a2683ef10338fc88c72999025256c2bdda6ed40"
    sha256 arm64_sonoma:  "e05d3c17c577b1532f32ea51a3b416630325a7d2d17a7bd272c28e06502a1424"
    sha256 arm64_ventura: "564589842cd32cca4030845add9c0ec5325db3d2ba84b72cc98b9936924c2cb5"
    sha256 sonoma:        "60fb71aa453096b23f0fe81d154e49f2c86c314eef8414123c5b3323f0e02e85"
    sha256 ventura:       "4c6a0bc4785229bdc7abe2a7c37aecb55e29a86a39ddf89adaf446e44c3050f6"
    sha256 x86_64_linux:  "3c59adfcd22bd261911dbf767a7b4321f933bd6bc3926278c751c46ea5c32d18"
  end

  depends_on "cmake" => :build
  depends_on "fypp" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "fftw"

  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"

  fails_with :clang # needs OpenMP support

  resource "libint" do
    url "https:github.comcp2klibint-cp2kreleasesdownloadv2.6.0libint-v2.6.0-cp2k-lmax-5.tgz"
    sha256 "1cd72206afddb232bcf2179c6229fbf6e42e4ba8440e701e6aa57ff1e871e9db"
  end

  # build patch to support libxc 7, upstream pr ref, https:github.comcp2kcp2kpull3828
  patch :DATA

  def install
    resource("libint").stage do
      system ".configure", "--enable-fortran", "--with-pic", *std_configure_args(prefix: libexec)
      system "make"
      ENV.deparallelize { system "make", "install" }
      ENV.prepend_path "PKG_CONFIG_PATH", libexec"libpkgconfig"
    end

    # TODO: Remove dbcsr build along with corresponding CMAKE_PREFIX_PATH
    # and add -DCP2K_BUILD_DBCSR=ON once `cp2k` build supports this option.
    system "cmake", "-S", "extsdbcsr", "-B", "build_psmpdbcsr",
                    "-DWITH_EXAMPLES=OFF",
                    *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build_psmpdbcsr"
    system "cmake", "--install", "build_psmpdbcsr"
    # Need to build another copy for non-MPI variant.
    system "cmake", "-S", "extsdbcsr", "-B", "build_ssmpdbcsr",
                    "-DUSE_MPI=OFF",
                    "-DWITH_EXAMPLES=OFF",
                    *std_cmake_args(install_prefix: buildpath"dbcsr")
    system "cmake", "--build", "build_ssmpdbcsr"
    system "cmake", "--install", "build_ssmpdbcsr"

    # Avoid trying to access procselfstatm on macOS
    ENV.append "FFLAGS", "-D__NO_STATM_ACCESS" if OS.mac?

    # Set -lstdc++ to allow gfortran to link libint
    cp2k_cmake_args = %w[
      -DCMAKE_SHARED_LINKER_FLAGS=-lstdc++
      -DCP2K_BLAS_VENDOR=OpenBLAS
      -DCP2K_USE_LIBINT2=ON
      -DCP2K_USE_LIBXC=ON
    ] + std_cmake_args

    system "cmake", "-S", ".", "-B", "build_psmpcp2k",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_PREFIX_PATH=#{libexec}",
                    *cp2k_cmake_args
    system "cmake", "--build", "build_psmpcp2k"
    system "cmake", "--install", "build_psmpcp2k"

    # Only build the main executable for non-MPI variant as libs conflict.
    # Can consider shipping MPI and non-MPI variants as separate formulae
    # or removing one variant depending on usage.
    system "cmake", "-S", ".", "-B", "build_ssmpcp2k",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMAKE_PREFIX_PATH=#{buildpath}dbcsr;#{libexec}",
                    "-DCP2K_USE_MPI=OFF",
                    *cp2k_cmake_args
    system "cmake", "--build", "build_ssmpcp2k", "--target", "cp2k-bin"
    bin.install Dir["build_ssmpcp2kbin*.ssmp"]

    (pkgshare"tests").install "testsFistwater.inp"
  end

  test do
    system bin"cp2k.ssmp", pkgshare"testswater.inp"
    system "mpirun", bin"cp2k.psmp", pkgshare"testswater.inp"
  end
end

__END__
diff --git aCMakeLists.txt bCMakeLists.txt
index 5ff48a4..273ba62 100644
--- aCMakeLists.txt
+++ bCMakeLists.txt
@@ -624,7 +624,7 @@ if(CP2K_USE_ELPA)
 endif()

 if(CP2K_USE_LIBXC)
-  find_package(LibXC 6 REQUIRED EXACT)
+  find_package(LibXC 7 REQUIRED)
 endif()

 # uncomment this when libgrpp cmake support is complete
diff --git acmakecp2kConfig.cmake.in bcmakecp2kConfig.cmake.in
index 6fec68c..63dee33 100644
--- acmakecp2kConfig.cmake.in
+++ bcmakecp2kConfig.cmake.in
@@ -60,7 +60,7 @@ if(NOT TARGET cp2k::cp2k)
   endif()

   if(@CP2K_USE_LIBXC@)
-    find_dependency(LibXC 6 REQUIRED EXACT)
+    find_dependency(LibXC 7 REQUIRED)
   endif()

   if(@CP2K_USE_COSMA@)
diff --git acmakemodulesFindLibXC.cmake bcmakemodulesFindLibXC.cmake
index 1c8a08d..821d55b 100644
--- acmakemodulesFindLibXC.cmake
+++ bcmakemodulesFindLibXC.cmake
@@ -12,8 +12,12 @@ include(cp2k_utils)
 cp2k_set_default_paths(LIBXC "LibXC")

 if(PKG_CONFIG_FOUND)
-  pkg_check_modules(CP2K_LIBXC IMPORTED_TARGET GLOBAL libxcf90 libxcf03
-                    libxc>=${LibXC_FIND_VERSION})
+  # For LibXC >= 7, the Fortran interface is only libxcf03
+  pkg_check_modules(CP2K_LIBXC
+    IMPORTED_TARGET GLOBAL
+    libxcf03
+    libxc>=7
+  )
 endif()

 if(NOT CP2K_LIBXC_FOUND)
@@ -25,11 +29,10 @@ if(NOT CP2K_LIBXC_FOUND)
   endforeach()
 endif()

-if(CP2K_LIBXC_FOUND
-   AND CP2K_LIBXCF90_FOUND
-   AND CP2K_LIBXCF03_FOUND)
+if(CP2K_LIBXC_FOUND)
+  # We require both libxc + libxcf03 for LibXC 7
   set(CP2K_LIBXC_LINK_LIBRARIES
-      "${CP2K_LIBXCF03_LIBRARIES};${CP2K_LIBXCF90_LIBRARIES};${CP2K_LIBXC_LIBRARIES}"
+    "${CP2K_LIBXCF03_LIBRARIES};${CP2K_LIBXC_LIBRARIES}"
   )
 endif()