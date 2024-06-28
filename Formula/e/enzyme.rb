class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.127.tar.gz"
  sha256 "d1318f6ab9c1dcad8467daf8ae76fc6b1c5a257e8dd0ed191b724e5c2c6f27e0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "76458b2ba9bc09f227b40254092e01d5b25c8d1e5b1b4ee20b16ead5ca306612"
    sha256 cellar: :any,                 arm64_ventura:  "176c94faca448a499b5f548a7c49c5b45207d1fe91191240afee5d3d5ec2d353"
    sha256 cellar: :any,                 arm64_monterey: "1bb5bcd367e2cb49c25f0b6860de4ca6ed4e957a4f8c892610c0f95584c99b57"
    sha256 cellar: :any,                 sonoma:         "51584db20ecf3a7390ff86289f32753a18321987bc2b4d034f9bfd9cf4da21ca"
    sha256 cellar: :any,                 ventura:        "6c2ae20c2e4f1feef2e7e53061f530a69cf40f9ef9adf6672c7425ed18adc7fa"
    sha256 cellar: :any,                 monterey:       "c9373033fec7d0705d9d65bf1f2d725e96b909fa6f37937ca158cd6547ca3270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8180c5523db1203ffd820dbcef2b33f205d7548a0b490605714d4266734491c"
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