class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https:www.cp2k.org"
  url "https:github.comcp2kcp2kreleasesdownloadv2023.2cp2k-2023.2.tar.bz2"
  sha256 "adbcc903c1a78cba98f49fe6905a62b49f12e3dfd7cedea00616d1a5f50550db"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "16d19e131dfe40d6774fb25680078077948ea0e8e7a71dac89df5e0a46d7c5a4"
    sha256 cellar: :any, arm64_ventura:  "a08b0a98ecac0d0625c0044b316a94f8667c6ce8afe7c9f7ff2697f4265de898"
    sha256 cellar: :any, arm64_monterey: "d69dec225c6ceb45a5b59c3c6876130bbb20730a5f7312a9c11b24578ce914bf"
    sha256 cellar: :any, sonoma:         "67803409aa250cab9fa820b5f70851a3a07661a96e92268c9471e07cc0ae5db6"
    sha256 cellar: :any, ventura:        "2b56dd29a9e449f86d245b0a49d3388636c4b0b0cec159f430f2f58b0b00676e"
    sha256 cellar: :any, monterey:       "71f02038d2e4fbb22e26f859935bc4c5b808df91e61de0f67e75ddb3145cfc87"
    sha256               x86_64_linux:   "e7c09a2661f7e5b61fcdc7683fd5c52904510c35a2644630c5ba896e25987f7f"
  end

  depends_on "python@3.11" => :build
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

      # libint needs `-lstdc++` (https:github.comcp2kcp2kblobmasterINSTALL.md)
      # Can remove if added upstream to Darwin-gfortran.psmp and Darwin-gfortran.ssmp
      # PR submitted: https:github.comcp2kcp2kpull2966
      libs = %W[
        -L#{Formula["fftw"].opt_lib}
        -lfftw3
        -lstdc++
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