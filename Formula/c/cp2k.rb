class Cp2k < Formula
  desc "Quantum chemistry and solid state physics software package"
  homepage "https:www.cp2k.org"
  url "https:github.comcp2kcp2kreleasesdownloadv2024.3cp2k-2024.3.tar.bz2"
  sha256 "a6eeee773b6b1fb417def576e4049a89a08a0ed5feffcd7f0b33c7d7b48f19ba"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "656ec352a778c93cf63db2b94fb0a8a4a625ee870cb1142577c37ff0ef955df2"
    sha256 arm64_ventura:  "395bda322226be6c02c76f2f79c48c22d1a2cf2c1ba840862c5ddcc4f9fddaa8"
    sha256 arm64_monterey: "2988a43d657dca0e9a8a040bf89cb0432775d20f517c6d26bb78c3c2c4a17ac5"
    sha256 sonoma:         "34a1c2e1da903636686466c125879207cb1be94b81d7007db2bd2283441b0bd7"
    sha256 ventura:        "492a1a316203602afc9641c274a3388892a2cf2b930b741f57138fc4c736ac7f"
    sha256 monterey:       "9075e9f4e099b87b12cf06a413798927f997ba4c345bf676c06ea8e72123b3d5"
    sha256 x86_64_linux:   "008ca4405c7596399de1a2c31261fa247b85603668f1f5ed86601d7ff1f9df2e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"

  uses_from_macos "python" => :build

  fails_with :clang # needs OpenMP support

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