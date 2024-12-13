class Sundials < Formula
  desc "Nonlinear and differentialalgebraic equations solver"
  homepage "https:computing.llnl.govprojectssundials"
  url "https:github.comLLNLsundialsreleasesdownloadv7.2.0sundials-7.2.0.tar.gz"
  sha256 "5c6c0a66a7e27c45bfb57b27f7579463855a85fc3976fed1d5c9dd88dc1ae3ab"
  license "BSD-3-Clause"

  livecheck do
    url "https:computing.llnl.govprojectssundialssundials-software"
    regex(href=.*?sundials[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1923f22a1ca2a93dd4b3a7b3a62886995548186892a2b6644545e6b735cb41bf"
    sha256 cellar: :any,                 arm64_sonoma:  "f03bf60cbe0df7308120164fdcf00721f1f0053ad685af62d81788f92889464b"
    sha256 cellar: :any,                 arm64_ventura: "3f79680a8517578b67926e3a98db2e6061d46983163cc8a2c5b0bc782e2913c9"
    sha256 cellar: :any,                 sonoma:        "86bacf2e9c55cda6847a409c0d87ce116328653b502f00ac05a6c988b195428c"
    sha256 cellar: :any,                 ventura:       "72db9c0775b89ef3ec7786f001a76d954e86afff2c18d9c915a416bc72a4f857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e221e692557a83842540c85a5caa0c0d51dc36adeb7095146da99f39a93e25"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  uses_from_macos "libpcap"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}suitesparse
      -DLAPACK_ENABLE=ON
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Only keep one example for testing purposes
    (pkgshare"examples").install Dir[prefix"examplesnvectorserial*"] \
                                  - Dir[prefix"examplesnvectorserial{CMake*,Makefile}"]
    rm_r(prefix"examples")
  end

  test do
    cp Dir[pkgshare"examples*"], testpath
    args = %W[
      -I#{include}
      -L#{lib}
      -lsundials_core
      -lsundials_nvecserial
      -lmpi
      -lm
    ]

    args += ["-I#{Formula["open-mpi"].opt_include}", "-L#{Formula["open-mpi"].opt_lib}"] if OS.mac?

    system ENV.cc, "test_nvector.c", "test_nvector_serial.c", "-o", "test", *args

    assert_match "SUCCESS: NVector module passed all tests", shell_output(".test 42 0")
  end
end