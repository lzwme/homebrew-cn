class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.267.tar.gz"
  sha256 "034e482578933e55dd46ec65a9d9a067243227da43fcad49c055fbd19b5d438c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5dc56803c2861bfca11532c6be0570b823ffa91ebb2f16167741353cb3bab8da"
    sha256 cellar: :any, arm64_sequoia: "ec5e63d41f1ae2730d4f8fc754e3b77e6023ee2e4858599aa477e513758f9c31"
    sha256 cellar: :any, arm64_sonoma:  "65f2c0caa3e7cbff6cf0d4eb7578151e0869051f14fd031fffe97d7cf9f182c9"
    sha256 cellar: :any, sonoma:        "2d5f3622fe808167ace499b170cceeef15687ccec06df4dd8666a27b5a68daa4"
    sha256 cellar: :any, arm64_linux:   "cf03346eb87142c94db1a3d6e3c0687391bb66a4159ce2fb46c8d7414591c77d"
    sha256 cellar: :any, x86_64_linux:  "e00321d08f4b4ffb6aa5f38aa17b19aab685cdfefac59f60f4eba04221d82547"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end