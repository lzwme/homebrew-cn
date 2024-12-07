class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.168.tar.gz"
  sha256 "c2776e411a58569396c713025ff7245a8e57ffc0318cc04422494a0c6dd5d444"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "74369bf4fb207d0ab69f8110dfbae2d73327ec3392272c56371daf25ce9d2e23"
    sha256 cellar: :any,                 arm64_sonoma:  "509e3afd4dff236917db80923242231560975093cf3b74d7d15916dfae5a6c15"
    sha256 cellar: :any,                 arm64_ventura: "3ca9d7bcc538baaddb843d2bfcaf1695eecdb4a35dc0441d1c75094fc26fc165"
    sha256 cellar: :any,                 sonoma:        "d43491b179a96b4cd0c131f22ebb76d7dbf54f1971153c2312e22fe91e73079a"
    sha256 cellar: :any,                 ventura:       "9d848adc70b4399b3ee827c5574642f500f0c69a765986db4f7e7aa3e2d53f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "917ad1199d27d722f6bbe9e2b96887b22bb61a9e464a185c053d055df2a0491d"
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