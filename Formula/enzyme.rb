class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.80.tar.gz", using: :homebrew_curl
  sha256 "773f9dc24541e02678bd314c3344aeb8c303e2664c8e42cb588c10d2eb6185e1"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "4a678f8693028ff85b76a08f0c009425b014c262a78510c4e590c0f4afd52211"
    sha256                               arm64_monterey: "b562bdd5393ba511c7d3ca4179ffa32a97096720a30bf353146daf862d32e538"
    sha256                               arm64_big_sur:  "704eb68ae79417bc80082c32b22479c106cc5414c90731e2cf93b959bcffe4e2"
    sha256                               ventura:        "bad0dc52d42e149612ce41b0b17558b8c74d2bc85d6b0fc1b120367ca201ca74"
    sha256                               monterey:       "c993f75df663889d14153bcd579e7cc8924f734afd4cebfed2c463963b7c9510"
    sha256                               big_sur:        "1af175cbdec640d7831681410d1d9e4f5c20b6d0a7994d53755f64752b97a3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6380ac867c68284240d2afe18c9125e04825432d67dd41c2d4f69a8ee4d11f"
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