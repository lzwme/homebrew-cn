class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https:people.engr.tamu.edudavissuitesparse.html"
  url "https:github.comDrTimothyAldenDavisSuiteSparsearchiverefstagsv7.4.0.tar.gz"
  sha256 "f9a5cc2316a967198463198f7bf10fb8c4332de6189b0e405419a7092bc921b7"
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
    sha256 cellar: :any,                 arm64_sonoma:   "2b62ca6c5fb9845c2fd9bcd3a606681ac2cd7760ab0139c228528a159f8bc9c0"
    sha256 cellar: :any,                 arm64_ventura:  "86cfa8cdeaff3471a91586d3b76bce6cd9afc9e133bc81e248d22e269702868b"
    sha256 cellar: :any,                 arm64_monterey: "40a58b89f331fea9a480379a2739c37fbab1ac7ddc642d9409237d90ad04bd95"
    sha256 cellar: :any,                 sonoma:         "38415edc4d50dff2585465391050ced0122eff8b65245f84267ea9e3f1a8359a"
    sha256 cellar: :any,                 ventura:        "c7367df0c43f8494b02be74c74437f0ca592159853bb0315fcd8c60ec83c369f"
    sha256 cellar: :any,                 monterey:       "106b95d079b9949e64ef017915bc97a7c8823ba42bd49259ca2c0b54c47a4667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df81c0682620ecc081d4c18ff11e51867097e7b71ceaf09e1dd7d2e17c7912b"
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