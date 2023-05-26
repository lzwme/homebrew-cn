class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.66.tar.gz", using: :homebrew_curl
  sha256 "4cd499d239d4af079f34ec7b77adc9c40fb82053bd37001abbe74296968b733e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6db2cd25209e3cd5c76a1d0d137aaa7fd69ca755a701aafdc8ba8ab629a63b14"
    sha256 cellar: :any,                 arm64_monterey: "600597cbe0589972c57fc2a5be9cda4d6011dd53b400563c4c7c89f947ff8b1b"
    sha256 cellar: :any,                 arm64_big_sur:  "da4d9e27efd1b56d697c0c8d040f267b21d9923ac17674b3d811c3ccd3c688f9"
    sha256 cellar: :any,                 ventura:        "c864934d4c63c6fd2182137b281a3339922b4783d3133980abba67a578eb29f1"
    sha256 cellar: :any,                 monterey:       "f499e0ecebd155b9f8915125f1c7b064498813d9a7f73d2038d36a69b39c108e"
    sha256 cellar: :any,                 big_sur:        "52af78a32943fe69c4c2d5adfab8539f55a323b7504238821efb5eb3454f90a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79264ce819420e3948104aaa278de2e360c65b55e06f70776e10517981db2876"
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