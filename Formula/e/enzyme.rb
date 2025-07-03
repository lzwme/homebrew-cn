class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.184.tar.gz"
  sha256 "07fa75f869e778ae29c017d3e2303d9da3b238588978e17d5612e50a365b9e9c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f60f1534e84cba9029f2a23bc35669c1e0b0d609ec4dbf0b80388d54d275574c"
    sha256 cellar: :any,                 arm64_sonoma:  "1cdaccdafbdd2d41170757f81c213895a53d5dc14434491080abe687ada73757"
    sha256 cellar: :any,                 arm64_ventura: "df07c1effe4fa6553148e2b4fce6bc3c4699a167375724fc656b7d3e3caa6f3c"
    sha256 cellar: :any,                 sonoma:        "cee793e3c5ae718f49c842419e7759d5c367a828c8a607864b9463caed6af02c"
    sha256 cellar: :any,                 ventura:       "0219bce160e9914b72404c2bf0946f9c6dc1a3d8a6ecc540bf221b1fe140878c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c46dc9fe36766c228ceab6dc2735165ad848bb84d1f8a770470763baf77105d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adad491d3fa1da772eca6b95559dad37ab0594855b4b4fd45c1be8f2476fd3cd"
  end

  depends_on "cmake" => :build
  depends_on "llvm@19"

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