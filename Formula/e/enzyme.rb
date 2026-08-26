class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.291.tar.gz"
  sha256 "90b6c050bdb9bf3c7e6a914ba0be26032dfa2e18074b4a9721a3fb75da3b5d83"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e77c8701e03cc5ffcc590e4008b72a042b7c8b2ecc592619ad7e06bf43ab44f"
    sha256 cellar: :any, arm64_sequoia: "8d97a49f009679c76976640764531fb7a255cb4c1ffb5bdcfd9822c3f5f71e55"
    sha256 cellar: :any, arm64_sonoma:  "2f7a007efc98385d06b63e61d0edb775e4297e2d69b63969cbb1ab0c7b648aff"
    sha256 cellar: :any, sonoma:        "8e6bdcfd72f1931cde4615f7297e560f2cbf31c71f18a10e62301aa01a1ef9a6"
    sha256 cellar: :any, arm64_linux:   "4f7edf806d6af02d347197bbecb96ed339432857fe1fa70b37ff3e0b31d7459a"
    sha256 cellar: :any, x86_64_linux:  "f87b136911add7b01e76a60d94ae2e88d09099fe2b6effea7f2967c527c66b0f"
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