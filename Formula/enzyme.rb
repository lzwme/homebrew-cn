class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.64.tar.gz", using: :homebrew_curl
  sha256 "797e90085e589c31696d6f22d774b4e9ffb88864f877cf28cb76946a6dda2c30"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5413fcae3dcc7bb8a893fb531f346102f53b7c45879996f193a9586f9c672554"
    sha256 cellar: :any,                 arm64_monterey: "ab8c4baa60072232a34ca087a70f58d7cc5e0945cbfdd34bf5b982d988aed486"
    sha256 cellar: :any,                 arm64_big_sur:  "1af6f6fb219a8ee84cc1c843b31bb74ac82ea79b1e974e4649cb8321c16fec16"
    sha256 cellar: :any,                 ventura:        "81745ea95d2adb0bb226fec1a6143ad6318024f534a727d60337708cbfd93cfb"
    sha256 cellar: :any,                 monterey:       "2c76b62df815cddfe48b0c399ee2fd280b36c1e06408f4c1626d41c3108a4479"
    sha256 cellar: :any,                 big_sur:        "401f9774bce1a80a6567e59d3f57a2231e7fbc6a69471bb037749a806fca0864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0caf4074fa6c1a69d8ea6472621e92aeb1e54f220d17bc559daabd7ccf6e586"
  end

  depends_on "cmake" => :build
  depends_on "llvm@15"

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