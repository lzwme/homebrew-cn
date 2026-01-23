class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.24.3.tar.gz"
  sha256 "dde6f6ef2c5ef8c473a831d56a2e3192b5304c50c4cc5ded7f296ef6d86aaf13"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_tahoe:   "9119494b98995f29ff691d2707db6a04318e140ac489d28a9a9d10cc177391d8"
    sha256 arm64_sequoia: "c7e3466e120160532a1131c27fb7401cc0010f86aeab7fb7e2de073e4d8afe2a"
    sha256 arm64_sonoma:  "128b17ec87d29b1b7fc17221bdbe7855b4171fa2e1f45fb29028aa0234da02ec"
    sha256 sonoma:        "6fcc5772d4dba002af16711df576da545a247b3aa7cab20e15f2f4cf932c1f5c"
    sha256 arm64_linux:   "182aae6dc66998aa513c1786fd9a3a7138de9f58d0dfa00cb062c914c242c697"
    sha256 x86_64_linux:  "5bc99acfbf977f7ca876740aa79be806ba8efcc5dc737116f7837da61ee12800"
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
                          "--with-fftw-dir=#{Formula["fftw"].opt_prefix}",
                          "--with-hdf5-dir=#{Formula["hdf5-mpi"].opt_prefix}",
                          "--with-hdf5-fortran-bindings=1",
                          "--with-metis-dir=#{Formula["metis"].opt_prefix}",
                          "--with-scalapack-dir=#{Formula["scalapack"].opt_prefix}",
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