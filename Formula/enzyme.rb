class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://ghproxy.com/https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.73.tar.gz", using: :homebrew_curl
  sha256 "989ee576d4558f4029587a06ae7432b5f0ce881b6a0bcb79164916ea5870dc11"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1f38d5d76dcd55e1bad1aa5d6e60c847487f382fad78c40e1695c6339b776d04"
    sha256 cellar: :any,                 arm64_monterey: "3edb6d152d4b0ef58eb5ef5f4478eb9e70506a2689524e99eb89368ad122c5ba"
    sha256 cellar: :any,                 arm64_big_sur:  "9edd71147742d71f3082f6797d63a442f7642eceac9fe9453e0b5d2781335910"
    sha256 cellar: :any,                 ventura:        "b8e8c5e94dcef80b9c47ff87446e2a8957ef1680f89da3168d9fedda128cd79e"
    sha256 cellar: :any,                 monterey:       "ac0cb806be51bfaa3cbebc5458aa8ed48ed75fbce47292c94db72de8687bb0f7"
    sha256 cellar: :any,                 big_sur:        "1dd2eda0f89e41283fc1774054a339ebdc786aaf584aee4a2d3e54fe45c763c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7039bf11c38286f6f039e051808c546c9125fe61e3615531c4abee36a6fd3c8e"
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