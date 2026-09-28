class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.296.tar.gz"
  sha256 "54b6efd172ce0729c79345ca0be9a4768dc902991f96bb336d83717174461d95"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7638f551a5eb8ffaacc75d3a7debfd0668d34e25cb4a306e13100a400fb27047"
    sha256 cellar: :any, arm64_tahoe:       "f295244b0a7677463a540be22a92b9b1f43e2c61447627e39c5e0efd643edd41"
    sha256 cellar: :any, arm64_sequoia:     "f86b23c2ff1f4c56e292a29eb10c15b4faa06d4e387fa70a2103aafb8cd29356"
    sha256 cellar: :any, arm64_linux:       "006b8e9d2f945ac4b104982a0865db6fb052e3ec15f0e2660bfcbaeb90a1122a"
    sha256 cellar: :any, x86_64_linux:      "42abe418d6f04d5c0369c6b5619eab0e7a09a98baf75edbddefaa10ccd6c6352"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  deny_network_access!

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