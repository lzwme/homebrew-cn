class DamaskGrid < Formula
  desc "Grid solver of DAMASK - Multi-physics crystal plasticity simulation package"
  homepage "https://damask-multiphysics.org"
  url "https://damask-multiphysics.org/download/damask-3.0.2.tar.xz"
  sha256 "82f9b3aefde87193c12a7c908f42b711b278438f6cad650918989e37fb6dbde4"
  license "AGPL-3.0-only"
  revision 3

  # The first-party website doesn't always reflect the newest version, so we
  # check GitHub releases for now.
  livecheck do
    url "https://github.com/damask-multiphysics/damask"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "67feb496cbf763457114298ff648c31d07a02b01b699c350acf420b16e6aa071"
    sha256 cellar: :any,                 arm64_sequoia: "34942e0fb23a92cdc84a2c98defb3b5f14192ac9ed4d8a52e6eb06c2cd7f4dee"
    sha256 cellar: :any,                 arm64_sonoma:  "a9f89ca390d98710fdf4b49f46d0db6ad5fd5e28624e99cf6cd5fc4c8eadeabf"
    sha256 cellar: :any,                 sonoma:        "0bc719369eea47492e6a96b48af2d4a880d1bc2aa01d942b65a27e3fc3d9a46e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57974533d52d8aa4a48d9b3ab8f02acf59871c7cc4d132c644a3ac663ad1f11c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b83351a277928dee503f38ef92a5fd1f74f7a3f62fde3a9e0c65b21a1da0e083"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "gcc" # gfortran
  depends_on "hdf5-mpi"
  depends_on "metis"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc"
  depends_on "scalapack"

  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  # Support PETSc 3.24.x
  # https://github.com/damask-multiphysics/DAMASK/commit/dc9aa42f04b9f5172b499c94328a22fed0ec6d9a
  patch :DATA

  def install
    # Help link to libomp on macOS to avoid mixed OpenMP
    inreplace "cmake/Compiler-GNU.cmake", '"-fopenmp"', '"-Xpreprocessor -fopenmp -lomp"' if OS.mac?

    ENV["PETSC_DIR"] = Formula["petsc"].opt_prefix
    args = %w[
      -DDAMASK_SOLVER=grid
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/grid"
  end

  test do
    if OS.mac?
      # Avoid mixed OpenMP linkage
      require "utils/linkage"
      libgomp = Formula["gcc"].opt_lib/"gcc/current/libgomp.dylib"
      refute Utils.binary_linked_to_library?(bin/"DAMASK_grid", libgomp), "Unwanted linkage to libgomp!"
    end

    cp_r pkgshare/"grid/.", testpath
    inreplace "tensionX.yaml" do |s|
      s.gsub! " t: 10", " t: 1"
      s.gsub! " t: 60", " t: 1"
      s.gsub! "N: 60", "N: 1"
      s.gsub! "N: 40", "N: 1"
    end

    args = %w[
      -w .
      -m material.yaml
      -g 20grains16x16x16.vti
      -l tensionX.yaml
      -j output
    ]
    system bin/"DAMASK_grid", *args
    assert_path_exists "output.hdf5", "output.hdf5 must exist"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 628e68d..4fb5df2 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -10,8 +10,11 @@ endif()
 # Dummy project to determine compiler names and version
 project(Prerequisites LANGUAGES)
 set(ENV{PKG_CONFIG_PATH} "$ENV{PETSC_DIR}/$ENV{PETSC_ARCH}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")
-pkg_check_modules(PETSC_MIN REQUIRED PETSc>=3.12.0 QUIET) #CMake does not support version range
-pkg_check_modules(PETSC REQUIRED PETSc<3.24.0)
+set(PETSC_VERSION_MINOR_MIN "15")
+set(PETSC_VERSION_MINOR_MAX "24")
+
+pkg_check_modules(PETSC_MIN REQUIRED PETSc>=3.${PETSC_VERSION_MINOR_MIN}.0 QUIET) #CMake does not support version range
+pkg_check_modules(PETSC REQUIRED PETSc<=3.${PETSC_VERSION_MINOR_MAX}.99)
 
 pkg_get_variable(CMAKE_Fortran_COMPILER PETSc fcompiler)
 pkg_get_variable(CMAKE_C_COMPILER PETSc ccompiler)
diff --git a/src/CLI.f90 b/src/CLI.f90
index 3bc472e..a285230 100644
--- a/src/CLI.f90
+++ b/src/CLI.f90
@@ -21,7 +21,7 @@
 !> @brief Parse command line interface for PETSc-based solvers
 !--------------------------------------------------------------------------------------------------
 #define PETSC_MINOR_MIN 12
-#define PETSC_MINOR_MAX 23
+#define PETSC_MINOR_MAX 24
 
 module CLI
   use, intrinsic :: ISO_fortran_env