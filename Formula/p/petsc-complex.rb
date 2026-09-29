class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.25.6.tar.gz"
  sha256 "00ac91c7ae96eae6a39d7380c7e869c1c7ddbc0c64a23a0b5fd3442227c7cdb9"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_golden_gate: "7bbfb43270db2ce2675d24c0fffecfc2c73592505e981fb26b0d56908f9935c7"
    sha256 arm64_tahoe:       "286bdb82503170b344f8e92eadb5aadbd68a45feb66317d387cdf037f04a8273"
    sha256 arm64_sequoia:     "d9c2aa52804dd8a84992e3a2e440418c0b12118459bb5d9bda44924f22671d0c"
    sha256 arm64_linux:       "8420ed9d4f127438038323a7cb0e6c36eb0123dc7a90465e80637f63f39f4bce"
    sha256 x86_64_linux:      "946ba06b4a3fc438066825601397f1a68ef93c9a7aa56be95501867d617b39a3"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "hdf5-mpi"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"
  depends_on "suite-sparse"

  uses_from_macos "python" => :build

  conflicts_with "petsc", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=complex",
                          "--with-x=0",
                          "--CC=mpicc",
                          "--CXX=mpicxx",
                          "--F77=mpif77",
                          "--FC=mpif90",
                          "--with-fftw-dir=#{formula_opt_prefix("fftw")}",
                          "--with-hdf5-dir=#{formula_opt_prefix("hdf5-mpi")}",
                          "--with-hdf5-fortran-bindings=1",
                          "--with-metis-dir=#{formula_opt_prefix("metis")}",
                          "--with-scalapack-dir=#{formula_opt_prefix("scalapack")}",
                          "MAKEFLAGS=$MAKEFLAGS"

    # Avoid references to Homebrew shims (perform replacement before running `make`, or else the shim
    # paths will still end up in compiled code)
    inreplace "arch-#{OS.kernel_name.downcase}-c-opt/include/petscconf.h", "#{Superenv.shims_path}/", ""

    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    rm(lib/"petsc/conf/configure-hash")

    if OS.mac? || File.foreach("#{lib}/petsc/conf/petscvariables").any? { |l| l[Superenv.shims_path.to_s] }
      inreplace lib/"petsc/conf/petscvariables", "#{Superenv.shims_path}/", ""
    end
  end

  test do
    flags = %W[-I#{include} -L#{lib} -lpetsc]
    flags << "-Wl,-rpath,#{lib}" if OS.linux?
    system "mpicc", share/"petsc/examples/src/ksp/ksp/tutorials/ex1.c", "-o", "test", *flags
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end