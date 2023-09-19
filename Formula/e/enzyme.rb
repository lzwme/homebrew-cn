class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.84.tar.gz", using: :homebrew_curl
  sha256 "1615288f06de51372c3500f77656b155dc42a6dec34e288dd0856cbd376b464c"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2872cfa0ce71e314209d5565209e729c19a9170424962e420b674fffeb21e6f7"
    sha256 cellar: :any,                 arm64_monterey: "dfc12abf930144b65b9e83723b0633dcf3cfaaaf015492bfa191293bb44afe39"
    sha256 cellar: :any,                 arm64_big_sur:  "58af782bf2034bab50927ab4af7c2a7afe50add92f80ef91a0a0b456110297fb"
    sha256 cellar: :any,                 ventura:        "03c465b84e1c7ed72ff1c3c9792fd29bb0c64275cf7a7e10c4ac0801a1dfe423"
    sha256 cellar: :any,                 monterey:       "2571a82afc2d865f0fa692e70ce0bec3b499092ab5de0170a17ffe11ed864e88"
    sha256 cellar: :any,                 big_sur:        "a7f14a5585e553ae0028a759930aa6d728d37455e167cf5c04b82fd77901d3bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10558d53f79e546d43bc900e52415d04451351eb02bb1c7cb16760fd33ee2c1b"
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