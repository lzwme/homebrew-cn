class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.76.tar.gz", using: :homebrew_curl
  sha256 "e2bd195e167374e7ac8f26d27554a37ff98f68787ab71738e2f1e92af4ba90e2"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8a5ec1112e7675192fcf9f0222cf7b193b0b251239538d18a8a046cbb28fd8a"
    sha256 cellar: :any,                 arm64_monterey: "ffaf4d570debd48a7786e208b30a22fd7022a9caed23fba8ca9de21b908c4166"
    sha256 cellar: :any,                 arm64_big_sur:  "28c9337cfdce3fca213302a2dad5d6db3f040f675adc1512e1a2a3d45dd1c41c"
    sha256 cellar: :any,                 ventura:        "ce7398be5cce49b6b8b0570e7a1c09b1fc1e0c266e9c62856f78c7bd54e461d3"
    sha256 cellar: :any,                 monterey:       "736e0b31bd1495e0e3990216be358825d5912035dcb94e9eb11b0a4985952e35"
    sha256 cellar: :any,                 big_sur:        "6f86a3cab44181543e46e8b7d0a42a23c18e5e6560c802edbec3b4f0f98665ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e589d76c138784256485c5fa0a9ef69dcdc1af8dcd9497b341f8c6ce2308acac"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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

    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    # `-Xclang -no-opaque-pointers` is a transitional flag for LLVM 15, and will
    # likely be need to removed in LLVM 16. See:
    # https://llvm.org/docs/OpaquePointers.html#version-support
    system ENV.cc, "-v", testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops",
                   "-Xclang", "-no-opaque-pointers"
    system opt, "input.ll", "--enable-new-pm=0",
                "-load=#{opt_lib/shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "--enzyme-attributor=0", "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end