class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.77.tar.gz", using: :homebrew_curl
  sha256 "73fe2715fe319f03af1bec9f0d6179daca2b557e558508242c99227fa89613b6"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fbd4e8c98c0bd98399ff72f0bf72241ac995f4c5d31eda33c645072494658644"
    sha256 cellar: :any,                 arm64_monterey: "076f6761d95abc6a95064657896c22cf4bbf78ca1631239f39e5132d0ab2c3e6"
    sha256 cellar: :any,                 arm64_big_sur:  "d417a008cf9d5364e3aba08e3bbe78cd6a16ca9c6eb792454b7c3f8d53d29f0b"
    sha256 cellar: :any,                 ventura:        "1de6da37d5723afe4d53ab589d271b16ed8aa5626be313d178b21be068b382e3"
    sha256 cellar: :any,                 monterey:       "6a9703b2a3bda30e7b341fa92b66a3c5d247ced8db1bf884ab9bcf72683314f0"
    sha256 cellar: :any,                 big_sur:        "126557cb9dcbd0082cb5e9281dec146ab5159a6a57d588ebd1d8c3cf90e9cd1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2703e2ded8b61b8969faae40339103600fd73a1cc9bd1bab03f7cf527c8268ff"
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