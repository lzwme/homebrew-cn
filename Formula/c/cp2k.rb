class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https:www.cp2k.org"
  url "https:github.comcp2kcp2kreleasesdownloadv2025.1cp2k-2025.1.tar.bz2"
  sha256 "65c8ad5488897b0f995919b9fa77f2aba4b61677ba1e3c19bb093d5c08a8ce1d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "46b2e75543dc15952e00a6614a0257225b5ed00d8c038cfb3546061a8e6446bb"
    sha256 arm64_sonoma:  "c2b1c3f70cc13fb9c89b8b5713a1702715e3ee01584ddb1113780ddfceeaf7ac"
    sha256 arm64_ventura: "1f4f74b1fcb70f1f88625059dfa197e5fd00cdd6560de061f8b7a709a3abec28"
    sha256 sonoma:        "d6b69ff15f5582ebe7093c86e9664aae11e1e2670eb428d83f774c2507592133"
    sha256 ventura:       "da3a27206ed2d1345338e3c764cf485cf003f13db52b38ec99be75eece741913"
    sha256 x86_64_linux:  "92120af9f50b710a84a8637f0294803f1ec745d4c49f3a9d19258955ded5e5bb"
  end

  depends_on "cmake" => :build
  depends_on "fypp" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "fftw"

  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"

  fails_with :clang do
    cause "needs OpenMP support for CC++ and Fortran"
  end

  resource "libint" do
    url "https:github.comcp2klibint-cp2kreleasesdownloadv2.6.0libint-v2.6.0-cp2k-lmax-5.tgz"
    sha256 "1cd72206afddb232bcf2179c6229fbf6e42e4ba8440e701e6aa57ff1e871e9db"
  end

  def install
    resource("libint").stage do
      system ".configure", "--enable-fortran", "--with-pic", *std_configure_args(prefix: libexec)
      system "make"
      ENV.deparallelize { system "make", "install" }
      ENV.prepend_path "PKG_CONFIG_PATH", libexec"libpkgconfig"
    end

    # TODO: Remove dbcsr build along with corresponding CMAKE_PREFIX_PATH
    # and add -DCP2K_BUILD_DBCSR=ON once `cp2k` build supports this option.
    system "cmake", "-S", "extsdbcsr", "-B", "build_psmpdbcsr",
                    "-DWITH_EXAMPLES=OFF",
                    *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build_psmpdbcsr"
    system "cmake", "--install", "build_psmpdbcsr"
    # Need to build another copy for non-MPI variant.
    system "cmake", "-S", "extsdbcsr", "-B", "build_ssmpdbcsr",
                    "-DUSE_MPI=OFF",
                    "-DWITH_EXAMPLES=OFF",
                    *std_cmake_args(install_prefix: buildpath"dbcsr")
    system "cmake", "--build", "build_ssmpdbcsr"
    system "cmake", "--install", "build_ssmpdbcsr"

    # Avoid trying to access procselfstatm on macOS
    ENV.append "FFLAGS", "-D__NO_STATM_ACCESS" if OS.mac?

    # Set -lstdc++ to allow gfortran to link libint
    cp2k_cmake_args = %w[
      -DCMAKE_SHARED_LINKER_FLAGS=-lstdc++
      -DCP2K_BLAS_VENDOR=OpenBLAS
      -DCP2K_USE_LIBINT2=ON
      -DCP2K_USE_LIBXC=ON
    ] + std_cmake_args

    system "cmake", "-S", ".", "-B", "build_psmpcp2k",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_PREFIX_PATH=#{libexec}",
                    *cp2k_cmake_args
    system "cmake", "--build", "build_psmpcp2k"
    system "cmake", "--install", "build_psmpcp2k"

    # Only build the main executable for non-MPI variant as libs conflict.
    # Can consider shipping MPI and non-MPI variants as separate formulae
    # or removing one variant depending on usage.
    system "cmake", "-S", ".", "-B", "build_ssmpcp2k",
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMAKE_PREFIX_PATH=#{buildpath}dbcsr;#{libexec}",
                    "-DCP2K_USE_MPI=OFF",
                    *cp2k_cmake_args
    system "cmake", "--build", "build_ssmpcp2k", "--target", "cp2k-bin"
    bin.install Dir["build_ssmpcp2kbin*.ssmp"]

    (pkgshare"tests").install "testsFistwater.inp"
  end

  test do
    system bin"cp2k.ssmp", pkgshare"testswater.inp"
    system "mpirun", bin"cp2k.psmp", pkgshare"testswater.inp"
  end
end