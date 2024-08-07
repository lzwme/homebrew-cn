class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https:people.engr.tamu.edudavissuitesparse.html"
  url "https:github.comDrTimothyAldenDavisSuiteSparsearchiverefstagsv7.8.0.tar.gz"
  sha256 "8ea989f36be3646d0b0eecb06218698766ca06256c0de15a64350e993bf5c5f9"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256                               arm64_sonoma:   "01c5abeebfdd5c9d0f8a4961fba7e9a02859745f5823a964bd99b3d6dd9ae725"
    sha256                               arm64_ventura:  "c2ba100bc4c9c5c1e349be0e9b8497097403a2f131976c5226ae3445c7b6c873"
    sha256                               arm64_monterey: "e4891cdbe8ff8fc925a7bc0dd93d410dabf2c6e0f4380fd815a44eb0787a921a"
    sha256                               sonoma:         "b18d85366d800c68ad209ba6267bde6df9fb46aace1deb3d8e08a74949361ce5"
    sha256                               ventura:        "2cb27e8672238e75e3a817f4598b3ae1391c96b5f593a7316b7f8310bf73f5d4"
    sha256                               monterey:       "853d5745a1366f69fddf8717201e3ec36e0a55646a34fbd2082976435469e3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8baa3989bd2819d6ca15627225cdf8f56242a7fb9745f9b9cc0095e5b7ebaa3"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "metis"
  depends_on "mpfr"

  uses_from_macos "m4"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    # Avoid references to Homebrew shims
    if OS.mac?
      inreplace "GraphBLAScmake_modulesGraphBLAS_JIT_configure.cmake",
          "C_COMPILER_BINARY \"${CMAKE_C_COMPILER}\"", "C_COMPILER_BINARY \"#{ENV.cc}\""
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "KLUDemoklu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare"klu_simple.c",
                   "-I#{include}suitesparse", "-L#{lib}",
                   "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath"test", :exist?
    assert_match "x [0] = 1", shell_output(".test")
  end
end