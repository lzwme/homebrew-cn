class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://petsc.org/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.19.1.tar.gz"
  sha256 "74db60c53c80b48d5c39e07bc39a883ecced88b9f24a5de17cf6f485a903e120"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "92aac1b02bda8e287d43627f42c4911872b2cce36d48afa8dd820b4f32cfcbe4"
    sha256 arm64_monterey: "4a4eded36dade090779a373a8299ebb99847128e7d337372f6b632286d252c0a"
    sha256 arm64_big_sur:  "98ada0a3c468e705da778146219a566191610ff6889bdb17234c28a8f3c68bdf"
    sha256 ventura:        "98b392b0bb29293b1b148a1218ff13ece96ac7c737f7d0ab2830cb66c3409079"
    sha256 monterey:       "443eb5008e141b23fa10be2e7927ebbfa16b15001042f5ef462ca51b9a0b476a"
    sha256 big_sur:        "7e1d2b9e20549f0014c8d4e0110fd71e8c719f3d266eef221ccfc3ef54cc5a9f"
    sha256 x86_64_linux:   "1d56cf4d77d767dc3ff9c8954d83d093aa4ce05988bcbc8fa556160d832c18c9"
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