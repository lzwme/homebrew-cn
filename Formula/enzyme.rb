class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.75.tar.gz", using: :homebrew_curl
  sha256 "3b6d28041daa1bae2bb6a5371426fa59f523a15a6ea54ab9ac4c45aff292b674"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b218dce8222cbd816521f525ce6dfa05c841ab83b5b5c6b17bc3446009d5770f"
    sha256 cellar: :any,                 arm64_monterey: "10c4f0b4b1317846999ea9ca5b325f4459a6ee39edc6ed3007d729a486095563"
    sha256 cellar: :any,                 arm64_big_sur:  "83f774282d1739a52ca294bafe6a760990f22a8ad64208809637bdc42d53a14d"
    sha256 cellar: :any,                 ventura:        "ec65e851c278c304c83bed4733981f1e15bab67fa9d38962786d7f446df1bf8b"
    sha256 cellar: :any,                 monterey:       "45b8177d88ca95bd7271364a906b0607b98dceda8e81ac926befa14f996084bf"
    sha256 cellar: :any,                 big_sur:        "bc8a898763152aa37eb70d2861ee16369e8581f7d8a7eb74513b520ef10a0944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a005a1208042e6728547f6f52fffd7a14d032c0f5b9b961dbf093da305a47cc"
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