class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.83.tar.gz", using: :homebrew_curl
  sha256 "1c4d33da77fc8d41470d7c992d94800e0cbe1232d73164be9183a7f6791ac61f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c2d91ff6992abe62e5104c85b47ef6242e4095637d006aa4bb73ac7c7d6a1413"
    sha256 cellar: :any,                 arm64_monterey: "6605a7731ef1aa19e6d9d8d31c11eaa3b9d076b5129aa0cd8c00fa7f410aee8c"
    sha256 cellar: :any,                 arm64_big_sur:  "9e5379d96dbb2fbf3ae8c893c1a69a96673ce10caf294ef93c032b5059027d60"
    sha256 cellar: :any,                 ventura:        "f10ed7f347c565b775e78e3e8bb06809bd8b32b84b9e39e74e2a52e88778f75c"
    sha256 cellar: :any,                 monterey:       "30976cad946351e13c95ac47f3166a50aed25155a79e23a617c083b902bcaef6"
    sha256 cellar: :any,                 big_sur:        "9da6019cd916b40a4d44b6e35af50a76cd23193b642304deb5bf268bfcb73011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a3b91b3b087a5c5fb7b6746794fdb6b483fba586ff53f7ba2c21e1da81fe192"
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