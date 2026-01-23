class DamaskGrid < Formula
  desc "Grid solver of DAMASK - Multi-physics crystal plasticity simulation package"
  homepage "https://damask-multiphysics.org"
  url "https://damask-multiphysics.org/download/damask-3.0.2.tar.xz"
  sha256 "82f9b3aefde87193c12a7c908f42b711b278438f6cad650918989e37fb6dbde4"
  license "AGPL-3.0-only"
  revision 2

  # The first-party website doesn't always reflect the newest version, so we
  # check GitHub releases for now.
  livecheck do
    url "https://github.com/damask-multiphysics/damask"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9df36df1df3c44fafd77ffe2f800f3d6d841551625ec03edba00707bf6e902ea"
    sha256 cellar: :any,                 arm64_sequoia: "47f893f9748b2f73b1bca5854ec9a7aa20472f36bee9369931603ca1fb0b45eb"
    sha256 cellar: :any,                 arm64_sonoma:  "aebce96fb01a23702698deeb0e09d517beacbf32a8c7cb9c210e9f5ea18f74af"
    sha256 cellar: :any,                 sonoma:        "110db396997a4063c67974f1816a00ff272ac2a2a5892a5387f5349bc61dc747"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52cd6629883662df732f93e125da1939c593a47bc5d5e5993acab75ba83dab8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f14f9441087d0102bffd6e43f4c3e87376fc79bc5029ee33b0c18aafcacef34c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fftw"
  depends_on "gcc"
  depends_on "hdf5-mpi"
  depends_on "metis"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "petsc"
  depends_on "scalapack"

  uses_from_macos "zlib"

  # Support PETSc 3.24.x
  # https://github.com/damask-multiphysics/DAMASK/commit/dc9aa42f04b9f5172b499c94328a22fed0ec6d9a
  patch :DATA

  def install
    ENV["PETSC_DIR"] = Formula["petsc"].opt_prefix
    args = %w[
      -DDAMASK_SOLVER=grid
    ]
    system "cmake", "-S", ".", "-B", "build-grid", *args, *std_cmake_args
    system "cmake", "--build", "build-grid", "--target", "install"

    pkgshare.install "examples/grid"
  end

  test do
    cp_r pkgshare/"grid", testpath
    cd "grid" do
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
      system "#{bin}/DAMASK_grid", *args
      assert_path_exists "output.hdf5", "output.hdf5 must exist"
    end
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