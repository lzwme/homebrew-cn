class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.157.tar.gz"
  sha256 "97fabcb178e66d1c267cf2e0d0bc9f4b1f8389bf9573396280dcc1f0123e8ac5"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca09d6a713b231e754401ea7455338c585a9fce15b9fcb6f510b777b435b670a"
    sha256 cellar: :any,                 arm64_sonoma:  "b6b71147c0127522312ca045a8de8adb53ed394c47c5c4009b2cac057ec804fa"
    sha256 cellar: :any,                 arm64_ventura: "5942099370e0dd8af43be0f1c4ff1daa5552c9e2987e3f51fa0ee2bb2d836196"
    sha256 cellar: :any,                 sonoma:        "37a3fe5cfebb9cdd64894086f6d8f202ebd583fe92469f875ad4f4b9545c57c3"
    sha256 cellar: :any,                 ventura:       "4cd4f9063c3efe8d18e355ad6a7de4c99315a915257aa66ef39b35b273245ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dfdc9c2f9a680ce1d5ee9e72500de1cd2a3a39a75c0252661a7075f16667bb5"
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