class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.3.tar.gz"
  sha256 "75a94fb44df0512f51ad093fa784e56b61f51b7ead5956fbe49185c203f8c245"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_sonoma:   "870d3bb9a6e1123a469426064a21d17eb5ebbe3060237d3ea152aa8c6b44f916"
    sha256 arm64_ventura:  "cf1b285e9febb6b0879cfeb02dbd5779dbbb63e1cb66e950bdecf84015494b15"
    sha256 arm64_monterey: "6021f98206d3519ad00cafc1471c161834d9d57dceed3122427709f8982404bd"
    sha256 sonoma:         "e30f9ed219d43301876c619f795276ef011a1102dff5595ff34908ac7329e70d"
    sha256 ventura:        "6b37fa7b3e58fb6bcf9316336ea124a4f5a068bfc06f22c51fff357ae91e6b05"
    sha256 monterey:       "2b062ccffa819b0a5cc9c990a5290b733065c7929bd8a1d9ca4e62af101b5f4e"
    sha256 x86_64_linux:   "f9af52ea4e83db94b5bbc5d39372cdc4a128687446aacb9ffcdcdef60193bcfe"
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