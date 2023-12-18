class Stp < Formula
  desc "Simple Theorem Prover, an efficient SMT solver for bitvectors"
  homepage "https:stp.github.io"
  url "https:github.comstpstparchiverefstags2.3.3.tar.gz"
  sha256 "ea6115c0fc11312c797a4b7c4db8734afcfce4908d078f386616189e01b4fffa"
  license "MIT"
  revision 8
  head "https:github.comstpstp.git", branch: "master"

  livecheck do
    url :stable
    regex(^(?:stp[._-])?v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b12c4a9145e67c68639ad6ab9600a56fff075d819163eadb8422c600761bf3ac"
    sha256 cellar: :any,                 arm64_ventura:  "6aadc8b0307425e991331316a590a32e2a58bfdff299fb88cc816dc8a5fa2e71"
    sha256 cellar: :any,                 arm64_monterey: "09a0b186febb6588ad2aef0c8d7be05ba1fcbb23a5f3cca900d57670d903ff0e"
    sha256 cellar: :any,                 sonoma:         "ccd8462d42b78b656a59cf50009e0a5ff684cbadb1782b6bd86f1d75fe5048d1"
    sha256 cellar: :any,                 ventura:        "ae42c8fc7e9a2cf3b87acab72c51236dcbdf49398ce6cf5b2226912ccd910161"
    sha256 cellar: :any,                 monterey:       "26bf5d1472e541b4d6971531544e268b804c75c4b87d4bef0b5c525c063d7d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d64345bfcdf48933e9199c07aa9363cdccc1c5e118776bf1d2d7b3395dce0ee4"
  end

  # stp refuses to build with system bison and flex
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost"
  depends_on "cryptominisat"
  depends_on "minisat"
  depends_on "python@3.12"

  uses_from_macos "perl"

  def install
    python = "python3.12"
    site_packages = prefixLanguage::Python.site_packages(python)
    site_packages.mkpath
    inreplace "libUtilGitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.12"].opt_bin}#{python}",
                    "-DPYTHON_LIB_INSTALL_DIR=#{site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"prob.smt").write <<~EOS
      (set-logic QF_BV)
      (assert (= (bvsdiv (_ bv3 2) (_ bv2 2)) (_ bv0 2)))
      (check-sat)
      (exit)
    EOS
    assert_equal "sat", shell_output("#{bin}stp --SMTLIB2 prob.smt").chomp

    (testpath"test.c").write <<~EOS
      #include "stpc_interface.h"
      #include <assert.h>
      int main() {
        VC vc = vc_createValidityChecker();
        Expr c = vc_varExpr(vc, "c", vc_bvType(vc, 32));
        Expr a = vc_bvConstExprFromInt(vc, 32, 5);
        Expr b = vc_bvConstExprFromInt(vc, 32, 6);
        Expr xp1 = vc_bvPlusExpr(vc, 32, a, b);
        Expr eq = vc_eqExpr(vc, xp1, c);
        Expr eq2 = vc_notExpr(vc, eq);
        int ret = vc_query(vc, eq2);
        assert(ret == false);
        vc_printCounterExample(vc);
        vc_Destroy(vc);
        return 0;
      }
    EOS

    expected_output = <<~EOS
      COUNTEREXAMPLE BEGIN:\s
      ASSERT( c = 0x0000000B );
      COUNTEREXAMPLE END:\s
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lstp", "-o", "test"
    assert_equal expected_output.chomp, shell_output(".test").chomp
  end
end