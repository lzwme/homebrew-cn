class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.145.tar.gz"
  sha256 "4268740d263904489443af0492e9c0659b9a3e17719ec136ad636d6d9ac9da46"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f81aaf5cd6c0afdafcf990c72fe7315443448858b1dff77c6b674174f7eeeb70"
    sha256 cellar: :any,                 arm64_ventura:  "d34fbe1ea6092b0e925dc75df0cdea1398bf01792f055354d817395353b533bf"
    sha256 cellar: :any,                 arm64_monterey: "8c986b07b49d41ec11c81ce27294e1d3b255b371610ab035d61625b0d9c1ae56"
    sha256 cellar: :any,                 sonoma:         "f580f2c643a59d104dcacd4879e8a56a4cc46c9ad724e1921f75d4fec3d72803"
    sha256 cellar: :any,                 ventura:        "e37dcfb3c3897c246cfb7c5b850ac826b307fd5ed9a3d4749a901a17256e3846"
    sha256 cellar: :any,                 monterey:       "db9452fa808a058b86ad7c59e512c70d64b913b39ec9d6b73e64d7db94e45148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "615b0f389533899e40b5e5103058561a96f820d64c89e8c0304264ff1c8de5ee"
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