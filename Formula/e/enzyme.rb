class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.294.tar.gz"
  sha256 "e427f1cb9368d00f16ce4b106d6cef0b1a371ef21bbb8f5abf72428c7db51e8e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e2ffddb57822ef4e4d432cd8221a8c675643103f0b3eccace6f3d9d7202e07da"
    sha256 cellar: :any, arm64_tahoe:       "2950771dd98bd87f6d87e7241848c3ce00b661fc5c815cc3dc4bede42aff46ba"
    sha256 cellar: :any, arm64_sequoia:     "696ad9b2f7c5ba78d1cadd487a2865c81e1fececf9695b414b9d30122e8c51bc"
    sha256 cellar: :any, arm64_linux:       "32beb2e8c84fa75d1658838aff179a8cb2121e100dcd13d4d09ea67b3cf8b21f"
    sha256 cellar: :any, x86_64_linux:      "ee5d2f24b731656dfa16373ba3ed741e390e720f6397af8f77d0fbdc4d670c04"
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