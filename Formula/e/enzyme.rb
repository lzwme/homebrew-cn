class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.251.tar.gz"
  sha256 "e3f8d06362b7a43134dbcbe339eac5c1b55b2e5f549b940081ece13d2a9ffab0"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ce799be9c6f155927533a1569a80aaf7679c2e617041fdbe5d87cf1c4139cc3c"
    sha256 cellar: :any,                 arm64_sequoia: "6d1415c3f673cbc8cb2dcb1fdedb01ec200d36067a3bc2c0ad2c80a4554fe4ff"
    sha256 cellar: :any,                 arm64_sonoma:  "324932ed98d11ea70914dd804460b795318776ed5a91fe3c5a57684a5601f3bb"
    sha256 cellar: :any,                 sonoma:        "5f5df5df770a913ddea279435b17da50f372e8fcec169dba20356993708496a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a400dd00c75a9e9913941f4e818b745aeb731043d597d52e1b26ee3c5bfc30c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f052f82f4863f44fcd0e55ac28021841f23617e502fdc5a824e7aee1e0ad1fc4"
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