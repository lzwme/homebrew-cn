class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.22.1.tar.gz"
  sha256 "7117d3ae6827f681ed9737939d4e86896b4751e27cca941bb07e5703f19a0a7b"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_sequoia: "209f254aef5e85b9bec2f0589b72608c87a23b0303b2b1e9413e7e7efc41797f"
    sha256 arm64_sonoma:  "3a6ae95598b71f4c3809144c68ae8d0e5afa5f5e4f9f30996c58416acb1d5488"
    sha256 arm64_ventura: "927b7160adffb77e33f529b2a49007e40946da62abb0b6059215918ff69b945b"
    sha256 sonoma:        "7b8ca80ba365fc591f85c1453619430b019b3b9437e599503f1243faff259513"
    sha256 ventura:       "70df54fb27fef8eb62ee3c5781b5b40e2bb9fd3a811505710dd2594355b68d1f"
    sha256 x86_64_linux:  "dacebcb7fdfb7ee5b0ca01074a5c824eb84f21db1d4f8c4da20ae0d0c3a6bcae"
  end

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