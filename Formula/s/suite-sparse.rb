class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https:people.engr.tamu.edudavissuitesparse.html"
  url "https:github.comDrTimothyAldenDavisSuiteSparsearchiverefstagsv7.9.0.tar.gz"
  sha256 "bc0b3987a502913959581614ab67098f9f203a45bb424870f2342375f96dbcb7"
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
    sha256                               arm64_sequoia: "13ebe1b870f88b1ea6e802f698a6c0b416e38e518f92315b9f17077ef867a923"
    sha256                               arm64_sonoma:  "03c11e2e6e1644117ed3df28c6bf0ceaccf756db4ec32ece31fe35e170a4c4b0"
    sha256                               arm64_ventura: "e300888d84454a39913042b9d0d14abf27d3393aa6ab1e9766b90612fd63275b"
    sha256                               sonoma:        "e0cb40d8cf59c04b23968816abc153b6700198beb8641277bdcca113b963ba1b"
    sha256                               ventura:       "e95e4b23b8065632fa1cacc272b6b31bef791d682be597dfef32de93a3896bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de3f23d7d009ff52da5875229959ea4d487a4b2eb56e10aca241e3db1f16d02"
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
    assert_path_exists testpath"test"
    assert_match "x [0] = 1", shell_output(".test")
  end
end