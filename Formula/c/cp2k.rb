class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https:www.cp2k.org"
  url "https:github.comcp2kcp2kreleasesdownloadv2024.1cp2k-2024.1.tar.bz2"
  sha256 "a7abf149a278dfd5283dc592a2c4ae803b37d040df25d62a5e35af5c4557668f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "afa1c6cdff4809dacea068dac134b2e8e861382d477f110e9bbdd4cc99513acb"
    sha256 cellar: :any, arm64_ventura:  "7bdd89ca6bb7254483dd6bdc185ca3fb524fbd544d61f8d183509b82f41fab80"
    sha256 cellar: :any, arm64_monterey: "cdbcdef206ab2a266eee36142264696fa1ce6e0ecd97a600522d2a54713bbfb9"
    sha256 cellar: :any, sonoma:         "72dcb6262d54fbde7d84104581388ddb54f164c7328479bea63aa085b9f98a18"
    sha256 cellar: :any, ventura:        "4d47f258b198986b4fda6643e1291ee146ea7ad57a3804f6be7853e7cabbed95"
    sha256 cellar: :any, monterey:       "06535d5670667a3254e14b3c1b2865f12d57d1962a19e84db4216c0d53a4800d"
    sha256               x86_64_linux:   "16055b3ba5722c5c73e2404970afb806bf4b72ae932f4e113320211a499ad0c2"
  end

  depends_on "python@3.12" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "scalapack"

  on_linux do
    depends_on "openblas"
  end

  fails_with :clang # needs OpenMP support

  resource "libint" do
    url "https:github.comcp2klibint-cp2kreleasesdownloadv2.6.0libint-v2.6.0-cp2k-lmax-5.tgz"
    sha256 "1cd72206afddb232bcf2179c6229fbf6e42e4ba8440e701e6aa57ff1e871e9db"
  end

  def install
    resource("libint").stage do
      ENV.append "FCFLAGS", "-fPIE" if OS.linux?
      system ".configure", "--prefix=#{libexec}", "--enable-fortran"
      system "make"
      ENV.deparallelize { system "make", "install" }
    end

    arch = "local"
    if OS.mac?
      arch = "Darwin-gfortran"

      libs = %W[
        -L#{Formula["fftw"].opt_lib}
        -lfftw3
      ]

      ENV["LIBXC_INCLUDE_DIR"] = Formula["libxc"].opt_include
      ENV["LIBXC_LIB_DIR"] = Formula["libxc"].opt_lib
      ENV["LIBINT_INCLUDE_DIR"] = libexec"include"
      ENV["LIBINT_LIB_DIR"] = libexec"lib"

      # CP2K configuration is done through editing of arch files
      inreplace Dir["archDarwin-gfortran.*"].to_a.each do |s|
        s.gsub!(DFLAGS *=, "DFLAGS = -D__FFTW3")
        s.gsub!(FCFLAGS *=, "FCFLAGS = -I#{Formula["fftw"].opt_include}")
        s.gsub!(LIBS *=, "LIBS = #{libs.join(" ")}")
      end

      # MPI versions link to scalapack
      inreplace Dir["archDarwin-gfortran.p*"].to_a,
                LIBS *=, "LIBS = -L#{Formula["scalapack"].opt_lib}"

      # OpenMP versions link to specific fftw3 library
      inreplace Dir["archDarwin-gfortran.*smp"].to_a,
                "-lfftw3", "-lfftw3 -lfftw3_threads"
    else
      args = %W[
        -j #{ENV.make_jobs}
        --mpi-mode=openmpi
        --math-mode=openblas
        --with-gcc=system
        --with-intel=no
        --with-cmake=no
        --with-openmpi=#{Formula["open-mpi"].opt_prefix}
        --with-mpich=no
        --with-intelmpi=no
        --with-libxc=#{Formula["libxc"].opt_prefix}
        --with-libint=#{libexec}
        --with-fftw=#{Formula["fftw"].opt_prefix}
        --with-acml=no
        --with-mkl=no
        --with-openblas=#{Formula["openblas"].opt_prefix}
        --with-scalapack=#{Formula["scalapack"].opt_prefix}
        --with-libxsmm=no
        --with-elpa=no
        --with-ptscotch=no
        --with-superlu=no
        --with-pexsi=no
        --with-quip=no
        --with-plumed=no
        --with-sirius=no
        --with-gsl=no
        --with-libvdwxc=no
        --with-spglib=no
        --with-hdf5=no
        --with-spfft=no
        --with-spla=no
        --with-cosma=no
        --with-libvori=no
        --with-libgrpp=no
      ]
      args << "--target-cpu=generic" if build.bottle?

      cd "toolstoolchain" do
        # Need OpenBLAS source to get proc arch info in scriptsget_openblas_arch.sh
        Formula["openblas"].stable.stage Pathname.pwd"buildOpenBLAS"

        system ".install_cp2k_toolchain.sh", *args
        (buildpath"arch").install (Pathname.pwd"installarch").children
      end
    end

    # Now we build
    %w[ssmp psmp].each do |exe|
      system "make", "ARCH=#{arch}", "VERSION=#{exe}"
      bin.install "exe#{arch}cp2k.#{exe}"
      bin.install "exe#{arch}cp2k_shell.#{exe}"
    end

    (pkgshare"tests").install "testsFistwater.inp"
  end

  test do
    system bin"cp2k.ssmp", pkgshare"testswater.inp"
    system "mpirun", bin"cp2k.psmp", pkgshare"testswater.inp"
  end
end