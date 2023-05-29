class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.67.tar.gz", using: :homebrew_curl
  sha256 "3626a72793c4ae0ab7ba67420a79645baaaef76dec59ecda5e321b15cd8c0e34"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "47a6b669683c8585666c8bfd20eaf4096f61f28ca054f7034860f16f9af6a704"
    sha256 cellar: :any,                 arm64_monterey: "5b41b3aad8279100d1de3cd8aab048896299dcad821a8a22dcac892cb1067bbb"
    sha256 cellar: :any,                 arm64_big_sur:  "1fef980cd6dc39f9815f5353c7b719f661e88c39157436382c2876b191056573"
    sha256 cellar: :any,                 ventura:        "7e106cbeace614d603589364ad0df49086ffd77950a2172ecaa325847333904e"
    sha256 cellar: :any,                 monterey:       "f037db97938fb33e8d9578f24635dca9422c02ef5b23ca3090dd57fcd767e3d2"
    sha256 cellar: :any,                 big_sur:        "4359f1b56e4e485a952af21ec642f54461d846e3cafdb200b7289afa0b48dd73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df8ee052ca22aa8389476e7972c5c02e0762a6d8861065c14491d996c80e67fa"
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