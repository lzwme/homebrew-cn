class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https:enzyme.mit.edu"
  url "https:github.comEnzymeADEnzymearchiverefstagsv0.0.164.tar.gz"
  sha256 "a6ca1f638cd1f78f5566e09a05fa04ad15762a2f9b0cdcf661fdfa78a99e345c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.comEnzymeADEnzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "99269165fa0f3aae04908ce135896e01e9d9891bcefdd94686f3fb68bf38997e"
    sha256 cellar: :any,                 arm64_sonoma:  "c589c03f16da6c4359f39f85c61a888e06621f4e73152ac320d7ebac9662d8eb"
    sha256 cellar: :any,                 arm64_ventura: "eddc03ccc7d63c8be1264eaa5163c31b7065da6c3c2aafa3791b916f3814d5ed"
    sha256 cellar: :any,                 sonoma:        "a9c7a6d0de24781f6c71b16d07b0fc9e10f971bda0f77f0cc63c135e2433cc49"
    sha256 cellar: :any,                 ventura:       "94bea1eae31b1e164845447ce354d4db9c51063de64b155e13ac7e9ba1f243eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32ba8633f3592ea8efc357e572ab5f30a40bca82addd1ba9c8c9dc8bd752727e"
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