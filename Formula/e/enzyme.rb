class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.134.tar.gz"
  sha256 "2436b303eee1d3582aadd2811b11db3bc564a6d9bd2aaec69cd3ea143e836294"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9eeb0fc4f19bb0246161b3237e4742852d099adde52f3dafc20e55c4f78d2054"
    sha256 cellar: :any,                 arm64_ventura:  "3a9dc9932843425860e4f985605c570a225b88c4b0494fc4350418b4b6160831"
    sha256 cellar: :any,                 arm64_monterey: "42bd50c5687c1b3bae6f48072decc8f6dffe86a44f6ea716a0e4922d9b297ffd"
    sha256 cellar: :any,                 sonoma:         "a803d82ba033c15bd884224b27cbb947c76f156b6b76529221e4010fc1ad28bb"
    sha256 cellar: :any,                 ventura:        "b06ed68ad62de1fde321cab037a38e761e4833633d8d7d12b36d05c598930a39"
    sha256 cellar: :any,                 monterey:       "69bf62aa33ad4f97c7b376371823b2a375eb0c9a52e34b3d82ec8657882a86ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e12b729c6d4ea6ccdc2d0bf7c153da451aaae53ede1f30265c094611587845"
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