class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.19.3.tar.gz"
  sha256 "008239c016b869693ec8e81368a0b7638462e667d07f7d50ed5f9b75ccc58d17"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "ef4f314b00b986f2f708e031c86e87a20d9113975b9f2e61806d906363be6ecd"
    sha256 arm64_monterey: "835be8b600b7c8568b81ba37e534af050a4c7cdc89316e5dfee6dd752505d2db"
    sha256 arm64_big_sur:  "5cc9b81e0b0c5fd394b7f9a78c1ac6388c754f487bb305b83abc88dc759d598d"
    sha256 ventura:        "31b593da13d924ac70b074d9d42e254daee09ecd2b4befab7c588e3ee77d8b87"
    sha256 monterey:       "461bf04cec69001be4c173687f5a2c4902db41b8d459151603af40ada7726492"
    sha256 big_sur:        "74fa388f8eccf8f8523ba4693a7aa8c8eb1a15d9cfc00b672d254a3bf1ba0c43"
    sha256 x86_64_linux:   "4e0dc401a5d7aaca4fa6871279ddba026957989037a80d9896b6aeeb652056c3"
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

    # Avoid references to Homebrew shims (perform replacement before running `make`, or else the shim
    # paths will still end up in compiled code)
    inreplace "arch-#{OS.kernel_name.downcase}-c-opt/include/petscconf.h", "#{Superenv.shims_path}/", ""

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