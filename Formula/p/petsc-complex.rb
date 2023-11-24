class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://petsc.org/"
  url "https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-3.20.1.tar.gz"
  sha256 "3d54f13000c9c8ceb13ca4f24f93d838319019d29e6de5244551a3ec22704f32"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    formula "petsc"
  end

  bottle do
    sha256 arm64_sonoma:   "43a544e334f3b77e7f40acd72e5bc8639ac5b27966c79bb8481f8183816a0475"
    sha256 arm64_ventura:  "62f4c18d5a58be87a2cbb16f280783af964e637b946687cb2a9ac79935fd34d0"
    sha256 arm64_monterey: "f7c2084e5c4c441212178dc29c4db8659fbcf3d4c9e931e243a4a053f9f29285"
    sha256 sonoma:         "ee51696462255fdc6b1c4d91df1b4766ea26aaed8499fa7f1f04c62bb3f8b7c8"
    sha256 ventura:        "e1a8fa13bd0fb236b053d04cc9f53881f8062ab2fd827f770081048ef9981efa"
    sha256 monterey:       "4ae984fb514fba298c1ffbc6b0b122f2aff6ea8b4bd63ac59025e88ca47b10bf"
    sha256 x86_64_linux:   "d8d4201852433316759aae4f8aa8e6a4ae3382c7800fd508cff09f49422119f2"
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