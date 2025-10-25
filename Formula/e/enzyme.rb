class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghfast.top/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.204.tar.gz"
  sha256 "f6624aa614e26b9bbb6d4d64bf3296dc937a9af004027c918ac85a95df8fd1f5"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ab3b87412b709a7495bca9056c2aebd6e59cf389e6d20a6b6ec82d2e9e092de"
    sha256 cellar: :any,                 arm64_sequoia: "9c3a28e09da6613d64727faf6c02eb6e1b3d3eb2970f087e44c92d47032912af"
    sha256 cellar: :any,                 arm64_sonoma:  "f4bd7d4d4df2686263133d4b994d45f485dd668394c0cc96747afa8cc44b28b5"
    sha256 cellar: :any,                 sonoma:        "15827deac271adbb9766cc35f2e601df0cf7dc4cc49be43c35ac8778a5de48e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dbd3c0cccb084dd43375338af4b2e3fc8b8194fefee781e8bf970ff4bf6836f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9755e02ccfa0dab6a378b84b9a6d2d6bf2166c2328626d4d775ad1104e243da9"
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