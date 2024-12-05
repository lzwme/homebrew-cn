class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.167.tar.gz"
  sha256 "78c80082bf5cb503420febfd14cd228e76a641a14c79a263637409901659d941"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "52a243860960cc3cb2a3b344adab633548902bc332ae7085b4deb40a95c4a4c3"
    sha256 cellar: :any,                 arm64_sonoma:  "5543043b24460bda2eb4ca9c80d6bf9584508beda7ef835e826d38913efc262a"
    sha256 cellar: :any,                 arm64_ventura: "92257c18174304913afcf63696f999ee5ecc30d0e7e263302b1970b4276691e2"
    sha256 cellar: :any,                 sonoma:        "9ff6c16a511dc8538b2a76a4e601783b82402560d70af0b14066c62a1040cc67"
    sha256 cellar: :any,                 ventura:       "99252f7b31833388d0dbf53646e19d60d4b25400f9e480e7adf606e1bbbb56fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "841b1de1db7933a1cb41bce2de85f01e6a2b129b984fcdef8b1fab7e53840ba0"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(^llvm(@\d+)?$) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}cmakellvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
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
    C

    ENV["CC"] = llvm.opt_bin"clang"

    system ENV.cc, testpath"test.c",
                        "-fplugin=#{libshared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output(".test")
  end
end