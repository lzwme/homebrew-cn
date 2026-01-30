class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https://www.cp2k.org/"
  url "https://ghfast.top/https://github.com/cp2k/cp2k/releases/download/v2026.1/cp2k-2026.1.tar.bz2"
  sha256 "4364c74bcffaa474bc234e11686b09550e4d06932acf2147a341e4f7679dd88e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "e70af7e7a56909fedd28848c17b44ce00c29f34c12c0fbb723be10723ee82674"
    sha256 arm64_sequoia: "f018ca0d07f46bda2f513bc82667d52244cbab4f1cacf6f1fcdc35afd56075ea"
    sha256 arm64_sonoma:  "5bb30a10df127ddec8771b2617f714916179eb2c3d20d61ed90b5be84728e998"
    sha256 sonoma:        "ef7f7871b366cefad40871dd9673af9fd3c17097a081328b9043e422ad410714"
    sha256 arm64_linux:   "e23fe5a58d5dc1d27d7ebc8984a32113ac7eb57c725b34cfab058d828e35d0cb"
    sha256 x86_64_linux:  "74b6992544967c31921136c39dc228201b92d46b32439617085cd263d0bb52b4"
  end

  depends_on "cmake" => :build
  depends_on "fypp" => :build
  depends_on "pkgconf" => :build

  depends_on "dbcsr"
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libint"
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    # Avoid over-optimizing fortran code as we don't have a shim for gfortran
    optflags = ENV["HOMEBREW_OPTFLAGS"].to_s.split.join(";")
    inreplace "cmake/CompilerConfiguration.cmake", "-march=native;-mtune=native", optflags

    # Avoid trying to access /proc/self/statm on macOS
    ENV.append "FFLAGS", "-D__NO_STATM_ACCESS" if OS.mac?

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCP2K_BLAS_VENDOR=OpenBLAS
      -DCP2K_USE_FFTW3=ON
      -DCP2K_USE_LIBINT2=ON
      -DCP2K_USE_LIBXC=ON
      -DCP2K_USE_MPI=ON
      -DCP2K_USE_MPI_F08=ON
    ]
    if OS.mac?
      args += %W[
        -DOpenMP_Fortran_LIB_NAMES=omp
        -DOpenMP_omp_LIBRARY=#{Formula["libomp"].opt_lib}/libomp.dylib
      ]
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"tests").install "tests/Fist/water.inp"
  end

  test do
    if OS.mac?
      require "utils/linkage"
      libgomp = Formula["gcc"].opt_lib/"gcc/current/libgomp.dylib"
      refute Utils.binary_linked_to_library?(lib/"libcp2k.dylib", libgomp), "Unwanted linkage to libgomp!"
    end

    system Formula["open-mpi"].bin/"mpirun", bin/"cp2k.psmp", pkgshare/"tests/water.inp"
  end
end