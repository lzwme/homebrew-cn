class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://ghfast.top/https://github.com/cp2k/cp2k/releases/download/v2025.1/cp2k-2025.1.tar.bz2"
  sha256 "65c8ad5488897b0f995919b9fa77f2aba4b61677ba1e3c19bb093d5c08a8ce1d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "7af6ab77ed39609075e8e08c7921f405c024dbf045dde7cf1ce6164aac550fd8"
    sha256 arm64_sequoia: "142ab8353ffe343a3adbb5bc83841a6037f1433379f7371ffa3b97e9ca33b051"
    sha256 arm64_sonoma:  "ff960f844b190cdffe23054a7d234012baf132db17928f2ffa4bb98c8023d946"
    sha256 sonoma:        "2b7c500da363bbb9a7466c1ab3612827803b769b689b55194cb62efbc9074c52"
    sha256 arm64_linux:   "14f388d665962f10f5692d5c280a150b79bc228ad93418e54e8befda5e30c590"
    sha256 x86_64_linux:  "7f19e8f4da26c16b8f3ff8f5a7c8965d6defe54e1212a8a5b20f8be87d0fee9a"
  end

  depends_on "cmake" => :build
  depends_on "fypp" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libint"
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"

  uses_from_macos "python" => :build

  fails_with :clang do
    cause "needs OpenMP support for C/C++ and Fortran"
  end

  def install
    # TODO: Add workaround to link to LLVM OpenMP (libomp) with gfortran after migrating OpenBLAS
    omp_args = []
    # if OS.mac?
    #   omp_args << "-DOpenMP_Fortran_LIB_NAMES=omp"
    #   omp_args << "-DOpenMP_omp_LIBRARY=#{Formula["libomp"].opt_lib}/libomp.dylib"
    # end

    # TODO: Remove dbcsr build along with corresponding CMAKE_PREFIX_PATH
    # and add -DCP2K_BUILD_DBCSR=ON once `cp2k` build supports this option.
    system "cmake", "-S", "exts/dbcsr", "-B", "build_psmp/dbcsr",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DWITH_EXAMPLES=OFF",
                    *omp_args, *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build_psmp/dbcsr"
    system "cmake", "--install", "build_psmp/dbcsr"
    # Need to build another copy for non-MPI variant.
    system "cmake", "-S", "exts/dbcsr", "-B", "build_ssmp/dbcsr",
                    "-DUSE_MPI=OFF",
                    "-DWITH_EXAMPLES=OFF",
                    *omp_args, *std_cmake_args(install_prefix: buildpath/"dbcsr")
    system "cmake", "--build", "build_ssmp/dbcsr"
    system "cmake", "--install", "build_ssmp/dbcsr"

    # Avoid trying to access /proc/self/statm on macOS
    ENV.append "FFLAGS", "-D__NO_STATM_ACCESS" if OS.mac?

    cp2k_cmake_args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(target: libexec/"lib")}
      -DCP2K_BLAS_VENDOR=OpenBLAS
      -DCP2K_USE_LIBINT2=ON
      -DCP2K_USE_LIBXC=ON
    ] + omp_args + std_cmake_args

    system "cmake", "-S", ".", "-B", "build_psmp/cp2k",
                    "-DCMAKE_PREFIX_PATH=#{libexec}",
                    *cp2k_cmake_args
    system "cmake", "--build", "build_psmp/cp2k"
    system "cmake", "--install", "build_psmp/cp2k"

    # Only build the main executable for non-MPI variant as libs conflict.
    # Can consider shipping MPI and non-MPI variants as separate formulae
    # or removing one variant depending on usage.
    system "cmake", "-S", ".", "-B", "build_ssmp/cp2k",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMAKE_PREFIX_PATH=#{buildpath}/dbcsr;#{libexec}",
                    "-DCP2K_USE_MPI=OFF",
                    *cp2k_cmake_args
    system "cmake", "--build", "build_ssmp/cp2k", "--target", "cp2k-bin"
    bin.install Dir["build_ssmp/cp2k/bin/*.ssmp"]

    (pkgshare/"tests").install "tests/Fist/water.inp"
  end

  test do
    system bin/"cp2k.ssmp", pkgshare/"tests/water.inp"
    system "mpirun", bin/"cp2k.psmp", pkgshare/"tests/water.inp"
  end
end