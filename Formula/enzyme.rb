class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.65.tar.gz", using: :homebrew_curl
  sha256 "c2684f7aa5ab259661ae18cc04e0ee51fe9a718a7e7cb7509f572a94b15cba4e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8262850fd40026a509482766cbb3fdd056858f44debdf80e456c13da94c5e39"
    sha256 cellar: :any,                 arm64_monterey: "e73a5a8cacd33c08ff4100c4b71fe482c620c05d8cdb9bc60c4eb78727b7b8f6"
    sha256 cellar: :any,                 arm64_big_sur:  "aaf46aaab52d6665c2ea564d27ca057e6773c9a0785e2a45ff137263dc3f38d1"
    sha256 cellar: :any,                 ventura:        "52d559768e58ffae3d8e4d3fd91c07a4f46ce840e25af91e9b5316803f903c3d"
    sha256 cellar: :any,                 monterey:       "e39018dc65aaa7de5730c1757dec10a3bf4dfb353ffb8eb62a74ae7c75c27bab"
    sha256 cellar: :any,                 big_sur:        "6cc63af732c57633be096152bf56ca8ee77f11991b63451f5bdd923e98e85392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd3eb99e436a525083d86f4df71dd8bad79eaeca737dc53aaba1db8ff5ba2691"
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