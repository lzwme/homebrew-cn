class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://ghfast.top/https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.12.3.tar.gz"
  sha256 "158ee4ed2ce3fdcbf52c4e47e94b0d1a8ae13344b4a835991d78a3ad20f08086"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "69dc395f19e4db47f3be66ba726630d7385a2a66030116e9927b294ded4cecb4"
    sha256               arm64_sequoia: "81ba313929e68de00691d0c875928dfcf2403c82ab2ebc1fc01ab7023adee31e"
    sha256               arm64_sonoma:  "9f0d3f2c4b94b1073dfa433222a418e518f2ce6621eddbbb5e113663d7d73b54"
    sha256               sonoma:        "06e102584631fca22763afd6f04789ff1da4dbfb6f14cf56936cc8872ca8499e"
    sha256 cellar: :any, arm64_linux:   "ea474615e8351403ca76fa6d62a0fcc9903e5c50326aec9c643d0ed79412c17d"
    sha256 cellar: :any, x86_64_linux:  "bfd5badae98bde5cc7e3294fcc447e16af29491f6336ad47e394162ca82adc0f"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "gmp"
  depends_on "mpfr"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    # CMake FortranCInterface_VERIFY fails with LTO on Linux due to different GCC and GFortran versions
    ENV.append "FFLAGS", "-fno-lto" if OS.linux?

    # Avoid references to Homebrew shims
    inreplace "GraphBLAS/cmake_modules/GraphBLAS_JIT_configure.cmake",
              "C_COMPILER_BINARY \"${CMAKE_C_COMPILER}\"", "C_COMPILER_BINARY \"#{ENV.cc}\""

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
                   "-I#{include}/suitesparse", "-L#{lib}",
                   "-lsuitesparseconfig", "-lklu"
    assert_path_exists testpath/"test"
    assert_match "x [0] = 1", shell_output("./test")

    if OS.mac?
      # Avoid mixed OpenMP linkage
      require "utils/linkage"
      libgomp = formula_opt_lib("gcc")/"gcc/current/libgomp.dylib"
      lib.glob("*.dylib").map(&:realpath).uniq.each do |dylib|
        refute Utils.binary_linked_to_library?(dylib, libgomp), "Unwanted linkage to libgomp in #{dylib.basename}!"
      end
    end
  end
end