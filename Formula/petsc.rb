class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.18.6.tar.gz"
  sha256 "8b53c8b6652459ba0bbe6361b5baf8c4d17c1d04b6654a76e3b6a9ab4a576680"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "675f1950ce5b4da4eb99e0aef09cad888e9fe9d5dbd4b58bfe60d7bb5aee4243"
    sha256 arm64_monterey: "93dcabd3d074c1b3bbf07e82076053594fbcbfb9ebe42e905344c6b79b2085e9"
    sha256 arm64_big_sur:  "1cd1f1414e3c8493b8fb7a0b9ec0979312a83eb5349279c89e5401237059bb4c"
    sha256 ventura:        "72d47b6c011cced7f48bc1392d2423f9fc7b24b606cebb0f2f568938330ace5d"
    sha256 monterey:       "aecffb0c013290211c425549acc535f9843df303e12b4154ee569f049a269115"
    sha256 big_sur:        "9e46f32cca3f27b76e5325c71081ccf06a9d59783dde6b57c1aca6d61a015173"
    sha256 x86_64_linux:   "06de10d5e44f6903f8c7acf539853b70478ced133f6f4bc7bc76e8d498078626"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"
  depends_on "suite-sparse"

  uses_from_macos "python" => :build

  conflicts_with "petsc-complex", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=real",
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
    system "mpicc", pkgshare/"examples/src/ksp/ksp/tutorials/ex1.c", "-o", "test", *flags
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end