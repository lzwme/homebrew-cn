class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://ghfast.top/https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.13.0.tar.gz"
  sha256 "561c0e2559f9e11d889d9b5fa7340e62aa8a183703292a524d138c36b80d4b50"
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
    sha256               arm64_tahoe:   "679c1209d7f1b2b6e64160cd20bce8af68f4b5d9aa982248649239543534cfa6"
    sha256               arm64_sequoia: "fb05a1a8fa9c2fccf996b300f11063774c8b06f798c235f79210f392b00432fe"
    sha256               arm64_sonoma:  "8cbef849f37c1577d691d6d413d4ae8a581ff2c5a47d0e8319f2314edc737fc4"
    sha256               sonoma:        "47d67a932e9c979e7252a9c833e041c4113e69ef767fede74da8a39e7e138968"
    sha256 cellar: :any, arm64_linux:   "c2d44c7852402376a9e780fa85deac801ba0f3185240221cc0570c0647d5d08b"
    sha256 cellar: :any, x86_64_linux:  "794e9426b1eeb5c26a0bf66e52fdc112fa47c3f093d21979bea4fa18cdaa1dbf"
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