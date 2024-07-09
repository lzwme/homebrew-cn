class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.133.tar.gz"
  sha256 "fd2c2ce644f312cada51786651f1185606c16c32525d8761951062d99970ddc9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "058584f5c41178bc39bb7da5880b589d6647c6a7bee0b5b86a01079bff1b5db1"
    sha256 cellar: :any,                 arm64_ventura:  "7df8b81445acdc4975c1c95676e1a18da7b315824334261c9c79fc99e79b1ebe"
    sha256 cellar: :any,                 arm64_monterey: "483376f721ed86b8b42dc9f494cfdbf8fdf4fe89b28c0c8c1d63fc7f2c391107"
    sha256 cellar: :any,                 sonoma:         "c1ed56f3ee5e1b3748b3b4ef3162a3d4a091e18db17bcdae44f9e647a3937736"
    sha256 cellar: :any,                 ventura:        "8eef6725f6418a7bfd9271040d76a4c2d2f95616cc6ed082f0570481afdce82d"
    sha256 cellar: :any,                 monterey:       "d22db35da5fd76ea19bc70bf2200ae42ef7f7f8ccde85c963a74bb3b5c938599"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c648ed0ef038cd6c5564511375528c589ea7dcdc89d7fffeebdcd14bf278ab3"
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