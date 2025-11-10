class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.211.tar.gz"
  sha256 "c6ba1fadbc24ef9fe5110b5f72b8d086b53237411701619474a2369936a72712"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "352f634b9fae2709cc2d30f9a569c8c601c327f831e28754f68291e1798acff0"
    sha256 cellar: :any,                 arm64_sequoia: "58cb076b872832e079c73fbddc7ac875c8ee4f77196e64c1f2be5ee27fa7f2f7"
    sha256 cellar: :any,                 arm64_sonoma:  "e231141b8cd3ab460c09901c367f2a1b69d57ee903fb58d3b884001e66956640"
    sha256 cellar: :any,                 sonoma:        "9cb6d6532c57a79d1d94e968b6afb1b6c61f39e5a5bc0427a468c609faad6770"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ec37423302ae3e1ae8f125604482b704e4bbf758555d745cd270e74bf9f1af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61713ef3e7ecd2febc611b65ee290a205d2f8faaa621feb2ee4be2fb04cac719"
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end