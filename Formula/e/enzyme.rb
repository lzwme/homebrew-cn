class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.135.tar.gz"
  sha256 "49c798534faec7ba524a3ed053dd4352d690a44d3cad5a14915c9398dc9b175b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fdfb5dc0d34129fa878a05c34a8e07f9e2b5856715a16dc7e6ec55d594d6f90d"
    sha256 cellar: :any,                 arm64_ventura:  "b9886afdfc7ca8781c86344528d714d62812f5a8dba6ab9d8b497b44037a28c9"
    sha256 cellar: :any,                 arm64_monterey: "7387ac9251198fda48e7a4ce216a71be0a96631bc4ee7617c98936c80f510bd8"
    sha256 cellar: :any,                 sonoma:         "68d7cc257e0b42db10e7a0d94cf2393606ea2c27c28d242192e09e5ee9cbeeb5"
    sha256 cellar: :any,                 ventura:        "7d19f3208c3f7a53056fbdc4824bec82deafab400e2cedbf8c8bd3229832ddc1"
    sha256 cellar: :any,                 monterey:       "dde2bee2d60f2dee2580b6edd40f5e7a01f78b425d0ace974195b3722ec5dde7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa48f6c9f8acf9033338d28dbd4cbc8f50a5c2ac474ea527e4ca4eacf883eac"
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