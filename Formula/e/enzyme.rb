class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.291.tar.gz"
  sha256 "90b6c050bdb9bf3c7e6a914ba0be26032dfa2e18074b4a9721a3fb75da3b5d83"
  license "Apache-2.0" => { with: "LLVM-exception" }
  revision 1
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b4dc47435323010a5535eaace2fbe668cdbefe466850d64412265c24591c5fa7"
    sha256 cellar: :any, arm64_sequoia: "83339ba5b91527afde0f0f40ab0247ca85533532a15df35a0634423d984aabf5"
    sha256 cellar: :any, arm64_sonoma:  "ae4169e8c1d6607a7d52a9d4c411b65c9e28d3dd387e33f12dea9eb13f5ce34a"
    sha256 cellar: :any, sonoma:        "7b8e0b5267c2dc6ce6723c86c7bec2388d5e67a67f15adf97df0c32fe4b0108b"
    sha256 cellar: :any, arm64_linux:   "bb0653a65d135445e0cb771174894930d2b738aa007e254121b34a6ba331da87"
    sha256 cellar: :any, x86_64_linux:  "689c56d4a2ee3e690c2e69f0e956407e5dcfa7e5309b78e6a0297500261c9d83"
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