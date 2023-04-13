class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  # TODO: Check if we can use unversioned `llvm` at version bump.
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/v0.0.53.tar.gz", using: :homebrew_curl
  sha256 "74bb882c0b639b3dd002a9a11babc87836b75ee83bdc47b6e1745c5e20032cd6"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "60aa3ea06b213c1d1de0fde6226bd3660bf9c0477ff4dbeb2c4c62c0e931f7d9"
    sha256 cellar: :any,                 arm64_monterey: "7641706345c37ade604f3aa56ec85390c9790b8003920bfff1c24029d316a254"
    sha256 cellar: :any,                 arm64_big_sur:  "5d5af4bc764509f103ff29a50a1e741fe7aef216f902d243290f1828aadc11dc"
    sha256 cellar: :any,                 ventura:        "191a6dec5102c08619b23f176d7f19a42c453ded1201e0fe3a9f6ea17559119b"
    sha256 cellar: :any,                 monterey:       "c8478662a0163233919c42c2afb06971d7610c4019deb6b749ae7a05e9243bfb"
    sha256 cellar: :any,                 big_sur:        "fcfa444a316da9a2e118352301e9ebe0cb25cc01e19fe1523fc6aa5c03d17013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad893f40a4ad559b5428a81d8d6bd056e08d5c9a605901fd15c51421de1eec3"
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