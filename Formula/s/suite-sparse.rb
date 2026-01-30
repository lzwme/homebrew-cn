class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://ghfast.top/https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v7.12.1.tar.gz"
  sha256 "794ae22f7e38e2ac9f5cbb673be9dd80cdaff2cdf858f5104e082694f743b0ba"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "b2239dc802de049f8117ed01d4db53111295c8f979f0cc13f130bdaffb130134"
    sha256                               arm64_sequoia: "42154870285bbf1e2be823b36125ca91f8ac0f90469a2bdc596da562038f4625"
    sha256                               arm64_sonoma:  "dad297853aa104caff17bacc59a0cf21c518cbec41f8660c38f521d5ad87186e"
    sha256                               sonoma:        "26c2236b3617bb5a2c0d122805fb12de98b678bad458bf43612f0bd9ef2b49c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c396c2fa68b97694e7367eae4cd3211d42cd46fda3a9db09480bed4cd1f9c7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5440c1dd0930f4f5653c8b9358df54a3860f51bd67b685ab616a172820e0bca"
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
      libgomp = Formula["gcc"].opt_lib/"gcc/current/libgomp.dylib"
      lib.glob("*.dylib").map(&:realpath).uniq.each do |dylib|
        refute Utils.binary_linked_to_library?(dylib, libgomp), "Unwanted linkage to libgomp in #{dylib.basename}!"
      end
    end
  end
end