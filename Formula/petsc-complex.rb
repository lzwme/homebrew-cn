class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.6.tar.gz"
  sha256 "8b53c8b6652459ba0bbe6361b5baf8c4d17c1d04b6654a76e3b6a9ab4a576680"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "9ba92601f1f5ac4ba232bbc8da273e02e10ae3bd4aec9400dda857eab00c9efc"
    sha256 arm64_monterey: "35aeb79c9e1140ad794f4f7b1cc14fa1d0c175a981a1451062d43c37c0c4b4cb"
    sha256 arm64_big_sur:  "7e047c4ed53304012c195722f00d17b16d4cc6188b994b06fef2fc6cc7a3090b"
    sha256 ventura:        "c26b7b4225e296d67bee0347bfcaf59e42edb6461298e689ec099d8f95add2f9"
    sha256 monterey:       "1dc92149adaf4bc7c60b2bea986558159a7d8b2cb2559ec6c10b312ba7e2eb89"
    sha256 big_sur:        "5bcab8d186c25233879a20f4275a97fc65308cd3673254f8a962e314b675141f"
    sha256 x86_64_linux:   "55ef350000ad3ce7029ed7378c5bc8a866eb03d8a7183a3b2411ea84a3998a63"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.11"
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
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    rm_f lib/"petsc/conf/configure-hash"

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