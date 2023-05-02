class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.59.tar.gz", using: :homebrew_curl
  sha256 "7bf5f46645bb448e5f160ac74235aa8ccc583e708f1a4a0e3ad48fb0b909e537"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "821a6a2bdb0a13fd139eebac710a616153804aaad93f5aa5c190294b0db38290"
    sha256 cellar: :any,                 arm64_monterey: "bb426811f752bcfb702fc6bf22634e26bb7589df63c13d2d37663d6bfc06fbf2"
    sha256 cellar: :any,                 arm64_big_sur:  "6d3f5dd705fd5ef2e2c1e0a829a6e5906309583c89f5b6dcf1aac5370fa9933a"
    sha256 cellar: :any,                 ventura:        "e1344824b9c1a9a493828d0aa8b71bd181b17f499ab0b3e64f890fa4920df442"
    sha256 cellar: :any,                 monterey:       "698ce0c715d00702749192783fb584768b296d47dcbdad76388459c75afdfeeb"
    sha256 cellar: :any,                 big_sur:        "6d5a4297659c025c3bec4bee551ce0d65fef2e5e42dcc79e254834cd4f2187a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48963e25c383b81206892aa60a71061b32e9f06714ad584e9fd8f70595e4496b"
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