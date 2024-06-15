class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.122.tar.gz"
  sha256 "8955e04f258b512307c92401869b3cc9f367af36f826c651a8d9c0eff5099b6c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e693d54e41fc1598249960a202e996332a94c4b511800eb768b9d7cb2625734d"
    sha256 cellar: :any,                 arm64_ventura:  "e743c1054e1e0350b61b9f664232adf3c974edc5b024bfd078978a0bd3dbbe3e"
    sha256 cellar: :any,                 arm64_monterey: "567cc09fa3b7b11f127493bb833453b886cb9ab4c7fa96e6b03c4ac1d7d168d1"
    sha256 cellar: :any,                 sonoma:         "7890ecfe5f0c690829cdbd38029b413668e7902679897069420b7e80410d6c5d"
    sha256 cellar: :any,                 ventura:        "840a3a36ce2335da8ad96cf4aced1b53a0e67c377636beb3f368be7c4cecca3e"
    sha256 cellar: :any,                 monterey:       "77879be66c131408ec996b1fb8a99fd47fda577992560b5a2ee81d37eb0c3fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9328ee6c8609832dbca9d5a8149f11507766937ca85f4d652304836a9513e703"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}cmakellvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    EOS

    ENV["CC"] = llvm.opt_bin"clang"

    system ENV.cc, testpath"test.c",
                        "-fplugin=#{libshared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output(".test")
  end
end