class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https:people.engr.tamu.edudavissuitesparse.html"
  url "https:github.comDrTimothyAldenDavisSuiteSparsearchiverefstagsv7.10.0.tar.gz"
  sha256 "cba761a322acfdf72d3db3c5b0bdd6da43742f348b092be5443d6a72d5f613e6"
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
    sha256                               arm64_sequoia: "e2e0b4c017b8d97fb77cb6d9a9af765e43e886d201d25c0972cc03afac7d84e1"
    sha256                               arm64_sonoma:  "2cbb2cca0f9b955acfe5a003d50112a9bd21e3284c6041260168e129cf890b63"
    sha256                               arm64_ventura: "667656ac221ae9e7ebd820545b29bf22e3e8a4a9ede242acb2bd793a4a509008"
    sha256                               sonoma:        "3ffcf0e04dbd00a56188ed3ffce9cfe8320e30836b5d9afb94fc1c8cf93d34a3"
    sha256                               ventura:       "98c3e74c3b63bfe6348dbc4cabe2ea74e733a07d98956a439137aaf330f91505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "863ef99361055deb7c49e9969dfec5cf138c8d2acd82d2c7b45a6a034802bc8f"
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