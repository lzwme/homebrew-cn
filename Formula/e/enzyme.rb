class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.160.tar.gz"
  sha256 "da8a6661e9250247324d3793d6aa382a650ba1b4dfb6b31083ef52fffe5b4de3"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ab516ab9d1399599901f9b0305405c80184f1944e5250673099f27ea6879a3c"
    sha256 cellar: :any,                 arm64_sonoma:  "508b8d9a7f277df2be3aa767afe3fe9d3f96e0f325781203410fc458506a1e90"
    sha256 cellar: :any,                 arm64_ventura: "a3a05083159c133d24fcd1519cf2433db027286a612c76c1b37b666b479c20d3"
    sha256 cellar: :any,                 sonoma:        "a8079bda838255b2f184e2f4b1dae153e1a275ff7694f0826a751d34f7fdd4bd"
    sha256 cellar: :any,                 ventura:       "df25a13aec03c90c5b01182a3fd84cfc65e92cfd4e0e7a3468b7b814dc1f559e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3a562226bba9f3b4c94160a18df3386682286ffcc73a425024994e2a18ff03e"
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