class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https:people.engr.tamu.edudavissuitesparse.html"
  url "https:github.comDrTimothyAldenDavisSuiteSparsearchiverefstagsv7.5.0.tar.gz"
  sha256 "9090ead43f462737369f1b6f8f269decc7f98adbb3276db299a2d4f18d481328"
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
    sha256 cellar: :any,                 arm64_sonoma:   "696f7166f02d1eaac01ed59221afb974b11208ba766e935f9293b320ebb1082b"
    sha256 cellar: :any,                 arm64_ventura:  "44767209c7093a9db39618cd12236e918d33cf51d0783f1172128adf8315f42c"
    sha256 cellar: :any,                 arm64_monterey: "f4a0c89cb73f99085cff773f407b05f3d88845b5dff36cf6acb16f3a50cfef32"
    sha256 cellar: :any,                 sonoma:         "84cedbedc5c5b7bd72820c07cb23f574fa431511b43efd9933909c94b1dfb4ba"
    sha256 cellar: :any,                 ventura:        "76d25bb0aa2e9eb6cc1ebb4438bf47249b1184b746d68f7b771c2e11234466ac"
    sha256 cellar: :any,                 monterey:       "da2f146aa17d426c1d997f33c87074ad171866746c823c3963d4185e0de55daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ecd4abb83f26260c1517175251dabc41301a09a80845aab8796368783b49131"
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