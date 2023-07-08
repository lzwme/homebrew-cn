class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.74.tar.gz", using: :homebrew_curl
  sha256 "50462d46f574e5f8cd3836e1b62b5d6f9d6edeb4905179c9806dacabf261745d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f112774ce2fd67ac9a69bd59140ad1de423b7ad3126db51a60a2984b5994a3f2"
    sha256 cellar: :any,                 arm64_monterey: "9edf4bdd2075eeca1645365ff330412282e8a7186a01d200f3e9ba15899382eb"
    sha256 cellar: :any,                 arm64_big_sur:  "36e33d50d7840679d3a36a876d8e46622f8cf1c7ecf577ec224b7632512c07f0"
    sha256 cellar: :any,                 ventura:        "d946f326d2d9eb1d866f4b5e2d54cd8f4ab51493f0ed82251024243501b79d80"
    sha256 cellar: :any,                 monterey:       "58bd5a5f94c25a5859afdae796f91c0449e732c9376584e0e9f95e1ece1c571b"
    sha256 cellar: :any,                 big_sur:        "3ae36b31b98765f397a1b7068473a7a80d9d2879eac75124217409dcdd8e4f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d638d4376b7fa1c98f9f69bbb1ec2f33d82fbb52dcac40f8b7aa85b8253b6bb7"
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