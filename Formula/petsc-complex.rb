class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.19.1.tar.gz"
  sha256 "74db60c53c80b48d5c39e07bc39a883ecced88b9f24a5de17cf6f485a903e120"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_ventura:  "98c7c6dbbf1796316b1b9b9103e2fcdf0670e6eae0b1acc64de0ca1a43946ff5"
    sha256 arm64_monterey: "d70aa5d479c7c1cb097cb90b5fe284ddd9b8830a596adffa7eaa6bdb97988669"
    sha256 arm64_big_sur:  "1e658ed62e5d9a21ad6004937e46011d1a80a6ca0c831423d3336a64aa32a74f"
    sha256 ventura:        "790f95b5c001b327eedc51165ce0c85f36315071e2241f0da1c8787eb0be8dda"
    sha256 monterey:       "eacfee29cc0b5a33627979699463faf0a875ebd7fd39b461c45607568b480fec"
    sha256 big_sur:        "a74248a34d8a6e7b69aeb72a5e2093bc848441f9eb9aa53d3f6ea792c26f7e0c"
    sha256 x86_64_linux:   "a25d64ce5e45cc1a0ae4a405bdb1ce80f1f10034182308a22edb40016778e6b3"
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
    inreplace "arch-#{OS.kernel_name.downcase}-c-opt/include/petscconf.h", "#{Superenv.shims_path}/", "" if OS.mac?

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