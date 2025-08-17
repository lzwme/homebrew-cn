class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.189.tar.gz"
  sha256 "09715387711df65d84247fa264fd6d6fdc386a31fead0d0dfd8a61b000310600"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "02f6f63b926395dea51e7c5d720eb11a92a90ca1216385e0ac293454fb7fc19b"
    sha256 cellar: :any,                 arm64_sonoma:  "09fcadac7eb7bc11da1fb25156d805efa0c3b4a40b0b93ea33357d79520feb03"
    sha256 cellar: :any,                 arm64_ventura: "e141f5a7d642c513e6294ee97ee6f0e30f4d417c2e266133f86953cd67b11c02"
    sha256 cellar: :any,                 sonoma:        "7597223af0f104741ae93c0c3c78ae1af4c36162228702781032338860da329b"
    sha256 cellar: :any,                 ventura:       "d91355f9a63bf65a86b5754445a9f868192fab61c88ad97924d3c432008f3eff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "001623c71ac03c66fac736b8842c60af69944ab46ecb7acba4cc47baa5ffad74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18a0182e2b5a0a1c53b2f0e84abfc5140e79c3b9f88c4c3bb799b4d4d87fc2f6"
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